require_relative 'search_test_properties'

module USCore
  module SearchTest
    extend Forwardable

    def_delegators 'self.class', :metadata
    def_delegators 'properties',
                   :resource_type,
                   :search_param_names,
                   :saves_delayed_references?,
                   :first_search?,
                   :fixed_value_search?,
                   :possible_status_search?,
                   :test_medication_inclusion?,
                   :token_search_params,
                   :test_reference_variants?,
                   :params_with_comparators
    # def self.included(klass)
    #   klass.extend(ClassMethods)
    # end

    # module ClassMethods
    # end

    def all_search_params
      @all_search_params ||=
        patient_id_list.each_with_object({}) do |patient_id, params|
          params[patient_id] ||= []
          new_params =
            if fixed_value_search?
              fixed_value_search_param_values.map { |value| fixed_value_search_params(value, patient_id) }
            else
              [search_params_with_values(patient_id)]
            end
          new_params.reject! { |params| params.any?(&:blank?) }

          params[patient_id].concat(new_params)
        end
    end

    def any_valid_search_params?
      all_search_params.any? { |_patient_id, params| params.present? }
    end

    def run_search_test
      # TODO: skip if not supported?
      skip_if !any_valid_search_params?, unable_to_resolve_params_message

      resources_returned =
        all_search_params.flat_map do |patient_id, params_list|
          params_list.flat_map { |params| perform_search(params, patient_id) }
        end

      skip_if resources_returned.empty?, no_resources_skip_message
    end

    def perform_search(params, patient_id)
      fhir_search resource_type, params: params

      perform_search_with_status(params, patient_id) if response[:status] == 400 && possible_status_search?

      assert_response_status(200)
      assert_resource_type(:bundle)

      # NOTE: do we even want to do any validation here?
      # assert_valid_bundle_entries(resource_types: [resource_type, 'OperationOutcome'])

      resources_returned =
        fetch_all_bundled_resources.select { |resource| resource.resourceType == resource_type }

      return [] if resources_returned.blank?

      perform_comparator_searches(params, patient_id) if params_with_comparators.present?

      # TODO: validate that responses match query

      all_scratch_resources.concat(resources_returned).uniq!
      scratch_resources_for_patient(patient_id).concat(resources_returned).uniq!

      save_delayed_references(resources_returned) if saves_delayed_references?

      return resources_returned if all_search_variants_tested?

      # TODO: handle search variants: POST
      test_medication_inclusion(resources_returned, params, patient_id) if test_medication_inclusion?
      perform_reference_with_type_search(params, resources_returned.count) if test_reference_variants?
      perform_search_with_system(params, patient_id) if token_search_params.present?

      resources_returned
    end

    def search_variant_test_records
      @search_variant_test_records ||= initial_search_variant_test_records
    end

    def initial_search_variant_test_records
      {}.tap do |records|
        records[:medication_inclusion] = false if test_medication_inclusion?
        records[:reference_variants] = false if test_reference_variants?
        records[:token_variants] = false if token_search_params.present?
        records[:comparator_searches] = Set.new if params_with_comparators.present?
      end
    end

    def all_search_variants_tested?
      search_variant_test_records.all? { |_variant, tested| tested.present? } &&
        all_comparator_searches_tested?
    end

    def all_comparator_searches_tested?
      return true if params_with_comparators.blank?

      Set.new(params_with_comparators) == search_variant_test_records[:comparator_searches]
    end

    def date_comparator_value(comparator, date)
      date = date.start || date.end if date.is_a? FHIR::Period
      case comparator
      when 'lt', 'le'
        comparator + (DateTime.xmlschema(date) + 1).xmlschema
      when 'gt', 'ge'
        comparator + (DateTime.xmlschema(date) - 1).xmlschema
      else
        # ''
        raise "Unsupported comparator '#{comparator}'"
      end
    end

    def required_comparators(name)
      metadata
        .search_definitions
        .dig(name.to_sym, :comparators)
        .select { |_comparator, expectation| expectation == 'SHALL' }
        .keys
        .map(&:to_s)
    end

    def perform_comparator_searches(params, patient_id)
      params_with_comparators.each do |name|
        next if search_variant_test_records[:comparator_searches].include? name

        required_comparators(name).each do |comparator|
          path = search_param_path(name)
          date_element = find_a_value_at(scratch_resources_for_patient(patient_id), path)
          params_with_comparator = params.merge(name => date_comparator_value(comparator, date_element))

          fhir_search resource_type, params: params_with_comparator

          assert_response_status(200)
          assert_resource_type(:bundle)

          # TODO: validate that responses match query
        end

        search_variant_test_records[:comparator_searches] << name
      end
    end

    def perform_reference_with_type_search(params, resource_count)
      return if resource_count == 0
      return if search_variant_test_records[:reference_variants]

      new_search_params = params.merge('patient' => "Patient/#{params['patient']}")
      fhir_search resource_type, params: new_search_params

      assert_response_status(200)
      assert_resource_type(:bundle)

      new_resource_count =
        fetch_all_bundled_resources
          .select { |resource| resource.resourceType == resource_type }
          .count

      assert new_resource_count == resource_count,
             "Expected search by `#{params['patient']}` to to return the same results as searching " \
             "by `#{new_search_params['patient']}`, but found #{resource_count} resources with " \
             "`#{params['patient']}` and #{new_resource_count} with `#{new_search_params['patient']}`"

      search_variant_test_records[:reference_variants] = true
    end

    def perform_search_with_system(params, patient_id)
      return if search_variant_test_records[:token_variants]

      new_search_params = token_search_params.each_with_object({}) do |name, search_params|
        search_params[name] = search_param_value(name, patient_id, include_system: true)
      end
      return if new_search_params.any? { |_name, value| value.blank? }

      search_params = params.merge(new_search_params)
      fhir_search resource_type, params: search_params

      assert_response_status(200)
      assert_resource_type(:bundle)

      resources_returned =
        fetch_all_bundled_resources
          .select { |resource| resource.resourceType == resource_type }

      assert resources_returned.present?, "No resources were returned when searching by `system|code`"

      search_variant_test_records[:token_variants] = true
    end

    def perform_search_with_status(original_params, patient_id)
      assert resource.is_a?(FHIR::OperationOutcome), "Server returned a status of 400 without an OperationOutcome"
      # TODO: warn about documenting status requirements
      status_search_values.flat_map do |status_value|
        search_params = original_params.merge('status': status_value)

        fhir_search resource_type, params: search_params

        assert_response_status(200)
        assert_resource_type(:bundle)

        entries = resource.entry.select { |entry| entry.resource.resourceType == 'Observation' }

        if entries.present?
          original_params.merge!('status': status_value)
          break
        end
      end
    end

    def status_search_values
      definition = metadata.search_definitions[:status]
      return [] if definition.blank?

      definition[:multiple_or] == 'SHALL' ? [definition[:values].join(',')] : [definition[:values]]
    end

    def test_medication_inclusion(medication_requests, params, patient_id)
      return if search_variant_test_records[:medication_inclusion]

      scratch[:medication] ||= {}
      scratch[:medication][:all] ||= []
      scratch[:medication][patient_id] ||= []
      scratch[:medication][:contained] ||= []

      requests_with_external_references =
        medication_requests
          .select { |request| request&.medicationReference&.present? }
          .reject { |request| request&.medicationReference&.reference&.start_with? '#' }

      scratch[:medication][:contained] +=
        medication_requests
          .select { |request| request&.medicationReference&.reference&.start_with? '#' }
          .flat_map(&:contained)
          .select { |resource| resource.resourceType == 'Medication' }

      return if requests_with_external_references.blank?

      search_params = params.merge(_include: 'MedicationRequest:medication')

      fhir_search resource_type, params: search_params

      assert_response_status(200)
      assert_resource_type(:bundle)

      medications = fetch_all_bundled_resources.select { |resource| resource.resourceType == 'Medication' }
      assert medications.present?, 'No Medications were included in the search results'

      scratch[:medication][:all] += medications
      scratch[:medication][:all].uniq!(&:id)
      scratch[:medication][patient_id] += medications
      scratch[:medication][patient_id].uniq!(&:id)

      search_variant_test_records[:medication_inclusion] = true
    end

    def all_scratch_resources
      scratch_resources[:all] ||= []
    end

    def scratch_resources_for_patient(patient_id)
      return all_scratch_resources if patient_id.nil?

      scratch_resources[patient_id] ||= []
    end

    def references_to_save
      @references_to_save ||= metadata.delayed_references.freeze
    end

    def fixed_value_search_param_name
      (search_param_names - ['patient']).first
    end

    def fixed_value_search_param_values
      metadata.search_definitions[fixed_value_search_param_name.to_sym][:values]
    end

    def fixed_value_search_params(value, patient_id)
      search_param_names.each_with_object({}) do |name, params|
        patient_id_param?(name) ? params[name] = patient_id : params[name] = value
      end
    end

    def search_params_with_values(patient_id)
      search_param_names.each_with_object({}) do |name, params|
        value = patient_id_param?(name) ? patient_id : search_param_value(name, patient_id)
        params[name] = value
      end
    end

    def patient_id_list
      return [nil] unless respond_to? :patient_ids

      patient_ids.split(',').map(&:strip)
    end

    def patient_search?
      search_param_names.any? { |name| patient_id_param? name }
    end

    def patient_id_param?(name)
      name == 'patient' || (name == '_id' && resource_type == 'Patient')
    end

    def search_param_path(name)
      path = metadata.search_definitions[name.to_sym][:path]
      path == 'class' ? 'local_class' : path
    end

    def all_search_params_present?(params)
      params.all? { |_name, value| value.present? }
    end

    def array_of_codes(array)
      array.map { |name| "`#{name}`" }.join(', ')
    end

    def unable_to_resolve_params_message
      "Could not find values for all search params #{array_of_codes(search_param_names)}"
    end

    def empty_search_params_message(empty_search_params)
      "Could not find values for the search parameters #{array_of_codes(empty_search_params.keys)}"
    end

    def no_resources_skip_message
      "No #{resource_type} resources appear to be available. " \
      "Please use patients with more information"
    end

    def fetch_all_bundled_resources(reply_handler: nil, max_pages: 20)
      page_count = 1
      resources = []
      bundle = resource

      until bundle.nil? || page_count == max_pages
        resources += bundle&.entry&.map { |entry| entry&.resource }
        next_bundle_link = bundle&.link&.find { |link| link.relation == 'next' }&.url
        reply_handler&.call(response)

        break if next_bundle_link.blank?

        reply = fhir_client.raw_read_url(next_bundle_link)
        # TODO:
        # store_request('outgoing') { reply }
        error_message = cant_resolve_next_bundle_message(next_bundle_link)

        assert_response_status(200)
        assert_valid_json(reply.body, error_message)

        bundle = fhir_client.parse_reply(FHIR::Bundle, fhir_client.default_format, reply)

        page_count += 1
      end

      resources
    end

    def cant_resolve_next_bundle_message(link)
      "Could not resolve next bundle: #{link}"
    end

    def find_a_value_at(element, path)
      return nil if element.nil?

      elements = Array.wrap(element)

      if path.empty?
        return elements.find { |el| yield(el) } if block_given?

        return elements.first
      end

      path_segments = path.split('.')
      segment = path_segments.shift.to_sym

      no_elements_present =
        elements.none? do |element|
          child = element.send(segment)

          child.present? || child == false
        end

      return nil if no_elements_present

      elements.each do |element|
        child = element.send(segment)
        element_found =
          if block_given?
            find_a_value_at(child, path_segments.join('.')) { |value_found| yield(value_found) }
          else
            find_a_value_at(child, path_segments.join('.'))
          end

        return element_found if element_found.present? || element_found == false
      end

      nil
    end

    def search_param_value(name, patient_id, include_system: false)
      path = search_param_path(name)
      element = find_a_value_at(scratch_resources_for_patient(patient_id), path)
      search_value =
        case element
        when FHIR::Period
          if element.start.present?
            'gt' + (DateTime.xmlschema(element.start) - 1).xmlschema
          else
            # TODO
            # end_datetime = get_fhir_datetime_range(element.end)[:end]
            # 'lt' + (end_datetime + 1).xmlschema
          end
        when FHIR::Reference
          element.reference
        when FHIR::CodeableConcept
          if include_system
            # TODO: fix if system is blank
            coding_with_code = find_a_value_at(element, 'coding') { |coding| coding.code.present? }
            coding_with_code.present? ? "#{coding_with_code.system}|#{coding_with_code.code}" : nil
          else
            find_a_value_at(element, 'coding.code')
          end
        when FHIR::Identifier
          if include_system
            # TODO: fix if system is blank
            "#{element.system}|#{element.value}"
          else
            element.value
          end
        when FHIR::Coding
          if include_system
            # TODO: fix if system is blank
            "#{element.system}|#{element.code}"
          else
            element.code
          end
        when FHIR::HumanName
          element.family || element.given&.first || element.text
        when FHIR::Address
          element.text || element.city || element.state || element.postalCode || element.country
        else
          element
        end
      escaped_value = search_value&.gsub(',', '\\,')
      escaped_value
    end

    def save_resource_reference(resource_type, reference)
      scratch[:references] ||= {}
      scratch[:references][resource_type] ||= Set.new
      scratch[:references][resource_type] << reference
    end

    def save_delayed_references(resources)
      resources.each do |resource|
        references_to_save.each do |reference_to_save|
          resolve_path(resource, reference_to_save[:path])
            .select { |reference| reference.is_a?(FHIR::Reference) && !reference.contained? }
            .each do |reference|
              resource_type = reference.resource_class.name.demodulize
              need_to_save = reference_to_save[:resources].include?(resource_type)
              next unless need_to_save

              save_resource_reference(resource_type, reference)
            end
        end
      end
    end

    def resolve_path(elements, path)
      elements = Array.wrap(elements)
      return elements if path.blank?

      paths = path.split('.')

      elements.flat_map do |element|
        resolve_path(element&.send(paths.first), paths.drop(1).join('.'))
      end.compact
    end
  end
end
