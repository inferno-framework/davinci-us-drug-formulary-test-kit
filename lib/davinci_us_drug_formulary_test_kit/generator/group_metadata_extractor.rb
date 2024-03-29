require_relative 'group_metadata'
require_relative 'ig_metadata'
require_relative 'must_support_metadata_extractor'
require_relative 'search_metadata_extractor'
require_relative 'terminology_binding_metadata_extractor'

module DaVinciUSDrugFormularyTestKit
  class Generator
    class GroupMetadataExtractor
      attr_accessor :resource_capabilities, :profile_url, :ig_metadata, :ig_resources

      def initialize(resource_capabilities, profile_url, ig_metadata, ig_resources)
        self.resource_capabilities = resource_capabilities
        self.profile_url = profile_url
        self.ig_metadata = ig_metadata
        self.ig_resources = ig_resources
      end

      def group_metadata
        @group_metadata ||=
          GroupMetadata.new(group_metadata_hash)
      end

      def group_metadata_hash
        @group_metadata_hash ||=
          {
            name:,
            class_name:,
            version:,
            reformatted_version:,
            resource:,
            profile_url:,
            profile_name:,
            profile_version:,
            title:,
            short_description:,
            interactions:,
            # operations: operations,
            searches:, # searches: searches,
            search_definitions:, # search_definitions: search_definitions
            include_params:,
            # revincludes: revincludes,
            must_supports:,
            mandatory_elements:,
            # bindings: bindings,
            references:
          }

        mark_mandatory_and_must_support_searches
        handle_special_cases

        @group_metadata_hash
      end

      def mark_mandatory_and_must_support_searches
        searches.each do |search|
          search[:names_not_must_support_or_mandatory] = search[:names].reject do |name|
            full_paths =
              search_definitions[name.to_sym][:full_paths]
                .map { |path| path.gsub(/\AResource\./, "#{resource}.") } # Fix for Resource.meta.*

            any_must_support_elements = must_supports[:elements].any? do |element|
              full_must_support_paths = ["#{resource}.#{element[:original_path]}", "#{resource}.#{element[:path]}"]

              full_paths.any? do |path|
                # allow for non-choice, choice types, and _id
                name == '_id' ||
                  full_must_support_paths.include?(path) ||
                  full_must_support_paths.include?("#{path}[x]")
              end
            end

            any_must_support_slices = must_supports[:slices].any? do |slice|
              # only handle type slices because that is all we need for now
              # for a slice like Observation.effective[x]:effectiveDateTime, the search parameter's expression could be
              # either Observation.effective or Observation.effectiveDateTime.
              if slice[:discriminator] && slice[:discriminator][:type] == 'type'
                full_must_support_path = "#{resource}.#{slice[:path].sub('[x]', slice[:discriminator][:code])}"
                base_must_support_path = "#{resource}.#{slice[:path].sub('[x]', '')}"

                full_paths.intersection([full_must_support_path, base_must_support_path]).present?
              else
                false
              end
            end

            any_must_support_extensions = must_supports[:extensions].any? do |extension|
              full_must_support_paths = ["#{resource}.#{extension[:path]}.where(url='#{extension[:url]}').value"]

              full_paths.any? { |path| full_must_support_paths.include?(path) }
            end

            any_mandatory_elements = mandatory_elements.any? do |element|
              full_paths.include?(element)
            end

            any_must_support_elements ||
              any_must_support_slices ||
              any_must_support_extensions ||
              any_mandatory_elements
          end

          search[:must_support_or_mandatory] = search[:names_not_must_support_or_mandatory].empty?
        end
      end

      ### BEGIN SPECIAL CASES ###

      def first_search_params
        @first_search_params ||=
          if resource == 'Location'
            ['_id']
          elsif resource == 'Basic'
            ['code']
          else
            ['status']
          end
      end

      def handle_special_cases
        set_first_search
        filter_drug_values
        add_must_support_choices
      end

      def set_first_search
        search = searches.find { |param| param[:names] == first_search_params }
        return if search.nil?

        searches.delete(search)
        searches.unshift(search)
      end

      def filter_drug_values
        search_definitions[:doseform][:values] = [] unless search_definitions[:doseform].nil?

        return if search_definitions[:code].nil?
        return unless search_definitions[:code][:full_paths] == ['MedicationKnowledge.code']

        search_definitions[:code][:values] = []
      end

      def add_must_support_choices
        choices = []
        case profile.type
        when 'Location'
          choices << { paths: ['address'],
                       extension_ids: ['Location.extension:region'] }
        end

        must_supports[:choices] = choices if choices.present?
      end

      ### END SPECIAL CASES ###

      def profile
        @profile ||= ig_resources.profile_by_url(profile_url)
      end

      def profile_elements
        @profile_elements ||= profile.snapshot.element
      end

      def base_name
        profile_url.split('StructureDefinition/').last
      end

      def name
        base_name.tr('-', '_')
      end

      def class_name
        base_name
          .split('-')
          .map(&:capitalize)
          .join
          .gsub('USDF', "USDF#{ig_metadata.reformatted_version}")
          .concat('Sequence')
      end

      def version
        ig_metadata.ig_version
      end

      def reformatted_version
        ig_metadata.reformatted_version
      end

      def resource
        resource_capabilities.type
      end

      def profile_name
        binding.pry if profile.nil?
        profile.title.gsub('  ', ' ')
      end

      def profile_version
        profile.version
      end

      def title
        profile.title.gsub(/US\s*Core\s*/, '').gsub(/\s*Profile/, '').strip
      end

      def short_description
        "Verify support for the server capabilities required by the #{profile_name}."
      end

      def interactions
        @interactions ||=
          resource_capabilities.interaction.map do |interaction|
            {
              code: interaction.code,
              expectation: interaction.extension.first.valueCode # TODO: fix expectation extension finding
            }
          end
      end

      # def operations
      #   @operations ||=
      #     resource_capabilities.operation.map do |operation|
      #       {
      #         code: operation.name,
      #         expectation: operation.extension.first.valueCode # TODO: fix expectation extension finding
      #       }
      #     end
      # end

      def search_metadata_extractor
        @search_metadata_extractor ||=
          SearchMetadataExtractor.new(resource_capabilities, ig_resources, resource, profile_elements)
      end

      def searches
        @searches ||= search_metadata_extractor.searches
      end

      def search_definitions
        @search_definitions ||= search_metadata_extractor.search_definitions
      end

      def include_params
        resource_capabilities.searchInclude || []
      end

      # def revincludes
      #   resource_capabilities.searchRevInclude || []
      # end

      # def terminology_binding_metadata_extractor
      #   @terminology_binding_metadata_extractor ||=
      #     TerminologyBindingMetadataExtractor.new(profile_elements, ig_resources, resource)
      # end

      # def bindings
      #   @bindings ||=
      #     terminology_binding_metadata_extractor.terminology_bindings
      # end

      def must_support_metadata_extractor
        @must_support_metadata_extractor ||=
          MustSupportMetadataExtractor.new(profile_elements, profile, resource, ig_resources)
      end

      def must_supports
        @must_supports ||=
          must_support_metadata_extractor.must_supports
      end

      def mandatory_elements
        @mandatory_elements ||=
          profile_elements
            .select { |element| element.min.positive? && parents_are_mandatory?(element) }
            .map(&:path)
            .uniq
      end

      def parents_are_mandatory?(element)
        return true if element.path.count('.') < 2

        parent_path = element.path.split('.')[0..-2].join('.')
        parent_element = profile_elements.find { |profile_element| profile_element.path == parent_path }

        parent_element&.min&.positive? && parents_are_mandatory?(parent_element)
      end

      def references
        @references ||= element_references + extension_references
      end

      def element_references
        profile_elements
          .select { |element| element.type&.first&.code == 'Reference' }
          .map do |reference_definition|
          {
            path: reference_definition.path,
            profiles: reference_definition.type.first.targetProfile
          }
        end
      end

      def extension_references
        profile_elements
          .select { |element| element.type.any? { |type| type.code == 'Extension' && type.profile.present? } }
          .map do |element|
          extension_url = element.type.first.profile.first

          target_profiles =
            ig_resources
              .profile_by_url(extension_url)
              &.snapshot
              &.element
              &.find { |profile_element| profile_element.id == 'Extension.value[x]:valueReference' }
              &.type
              &.first
              &.targetProfile

          next if target_profiles.blank?

          {
            path: "#{element.path}.where(url='#{extension_url}').valueReference",
            target_profiles:
          }
        end.compact
      end
    end
  end
end
