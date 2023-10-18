require_relative 'value_extractor'

module DaVinciPDEXDrugFormularyTestKit
  class Generator
    class MustSupportMetadataExtractor
      attr_accessor :profile_elements, :profile, :resource, :ig_resources

      def initialize(profile_elements, profile, resource, ig_resources)
        self.profile_elements = profile_elements
        self.profile = profile
        self.resource = resource
        self.ig_resources = ig_resources
      end

      def must_supports
        @must_supports = {
          extensions: must_support_extensions,
          slices: must_support_slices,
          elements: must_support_elements
        }
        # handle_special_cases

        @must_supports
      end

      def is_uscdi_requirement_element?(element)
        element.extension.any? do |extension|
          extension.url == 'http://hl7.org/fhir/us/core/StructureDefinition/uscdi-requirement' &&
            extension.valueBoolean
        end && !element.mustSupport
      end

      def all_must_support_elements
        profile_elements.select { |element| element.mustSupport || is_uscdi_requirement_element?(element) }
      end

      def must_support_extension_elements
        all_must_support_elements.select do |element|
          (element.path.end_with? 'extension') && !element&.type&.first&.profile&.first.nil?
        end
      end

      def must_support_extensions
        must_support_extension_elements.map do |element|
          {
            id: element.id,
            url: element.type.first.profile.first,
            path: element.path.gsub("#{resource}.", '')
          }.tap do |metadata|
            metadata[:uscdi_only] = true if is_uscdi_requirement_element?(element)
          end
        end
      end

      def must_support_slice_elements
        all_must_support_elements.select do |element|
          !element.path.end_with?('extension') && element.sliceName.present?
        end
      end

      # TODO: fi-2241 (see known issues) - MS elements within MS slices need to be under
      # "slices" in the metadata, rather than "elements"

      # def slice_sub_elements
      #   must_support_slice_elements.flat_map do |slice|
      #     profile_elements.select do |element|
      #       element.id != slice.id && element.id.start_with?(slice.id) && element.mustSupport
      #     end
      #   end
      # end

      # def slice_sub_elements_content
      #   slice_sub_elements.map do |x|
      #     {
      #       name: x.id,
      #       path: x.path
      #     }
      #   end
      # end

      def sliced_element(slice)
        profile_elements.find do |element|
          (element.id == slice.path && element.slicing.present?) || element.id == slice.id.sub(":#{slice.sliceName}",
                                                                                               '')
        end
      end

      def discriminators(slice)
        slice.slicing.discriminator
      end

      def must_support_pattern_slice_elements
        must_support_slice_elements.select do |element|
          discriminators(sliced_element(element)).first.type == 'pattern'
        end
      end

      def pattern_slices
        must_support_pattern_slice_elements.map do |current_element|
          {
            name: current_element.id,
            path: current_element.path.gsub("#{resource}.", '')
          }.tap do |metadata|
            discriminator = discriminators(sliced_element(current_element)).first
            discriminator_path = discriminator.path
            discriminator_path = '' if discriminator_path == '$this'
            pattern_element =
              if discriminator_path.present?
                profile_elements.find { |element| element.id == "#{current_element.id}.#{discriminator_path}" }
              else
                current_element
              end

            metadata[:discriminator] =
              if pattern_element.patternCodeableConcept.present?
                {
                  type: 'patternCodeableConcept',
                  path: discriminator_path,
                  code: pattern_element.patternCodeableConcept.coding.first.code,
                  system: pattern_element.patternCodeableConcept.coding.first.system
                }
              elsif pattern_element.patternCoding.present?
                {
                  type: 'patternCoding',
                  path: discriminator_path,
                  code: pattern_element.patternCoding.code,
                  system: pattern_element.patternCoding.system
                }
              elsif pattern_element.patternIdentifier.present?
                {
                  type: 'patternIdentifier',
                  path: discriminator_path,
                  system: pattern_element.patternIdentifier.system
                }
              elsif pattern_element.binding&.strength == 'required' &&
                    pattern_element.binding&.valueSet.present?

                value_extractor = ValueExactor.new(ig_resources, resource, profile_elements)

                values = value_extractor.values_from_value_set_binding(pattern_element).presence ||
                         value_extractor.values_from_resource_metadata([metadata[:path]]).presence || []

                {
                  type: 'requiredBinding',
                  path: discriminator_path,
                  values:
                }
              else
                raise StandardError, 'Unsupported discriminator pattern type'
              end

            metadata[:uscdi_only] = true if is_uscdi_requirement_element?(current_element)
          end
        end
      end

      def must_support_type_slice_elements
        must_support_slice_elements.select do |element|
          discriminators(sliced_element(element)).first.type == 'type'
        end
      end

      def type_slices
        must_support_type_slice_elements.map do |current_element|
          discriminator = discriminators(sliced_element(current_element)).first
          type_path = discriminator.path
          type_path = '' if type_path == '$this'
          type_element =
            if type_path.present?
              elements.find { |element| element.id == "#{current_element.id}.#{type_path}" }
            else
              current_element
            end

          type_code = type_element.type.first.code

          {
            name: current_element.id,
            path: current_element.path.gsub("#{resource}.", ''),
            discriminator: {
              type: 'type',
              code: type_code.upcase_first
            }
          }.tap do |metadata|
            metadata[:uscdi_only] = true if is_uscdi_requirement_element?(current_element)
          end
        end
      end

      def must_support_value_slice_elements
        must_support_slice_elements.select do |element|
          discriminators(sliced_element(element)).first.type == 'value'
        end
      end

      def value_slices
        must_support_value_slice_elements.map do |current_element|
          {
            name: current_element.id,
            path: current_element.path.gsub("#{resource}.", ''),
            discriminator: {
              type: 'value'
            }
          }.tap do |metadata|
            metadata[:discriminator][:values] = discriminators(sliced_element(current_element)).map do |discriminator|
              if discriminator.path == '$this'
                {
                  path: discriminator.path,
                  value: current_element.path
                }
              else
                fixed_element = profile_elements.find do |element|
                  element.id.starts_with?(current_element.id) &&
                    element.path == "#{current_element.path}.#{discriminator.path}"
                end
                {
                  path: discriminator.path,
                  value: fixed_element.fixedUri || fixed_element.fixedCode
                }
              end
            end

            metadata[:uscdi_only] = true if is_uscdi_requirement_element?(current_element)
          end
        end
      end

      def must_support_slices
        pattern_slices + type_slices + value_slices
        # TODO: for fi-2241
        # pattern_slices + type_slices + value_slices + slice_sub_elements_content
      end

      def plain_must_support_elements
        all_must_support_elements - must_support_extension_elements - must_support_slice_elements
        # TODO: for fi-2241
        # all_must_support_elements - must_support_extension_elements - must_support_slice_elements - slice_sub_elements
      end

      def handle_fixed_values(metadata, element)
        if element.fixedUri.present?
          metadata[:fixed_value] = element.fixedUri
        elsif element.patternCodeableConcept.present?
          metadata[:fixed_value] = element.patternCodeableConcept.coding.first.code
          metadata[:path] += '.coding.code'
        elsif element.fixedCode.present?
          metadata[:fixed_value] = element.fixedCode
        elsif element.patternIdentifier.present?
          metadata[:fixed_value] = element.patternIdentifier.system
          metadata[:path] += '.system'
        end
      end

      def type_must_support_extension?(extensions)
        extensions&.any? do |extension|
          extension.url == 'http://hl7.org/fhir/StructureDefinition/elementdefinition-type-must-support' &&
            extension.valueBoolean
        end
      end

      def save_type_code?(type)
        type.code == 'Reference'
      end

      def get_type_must_support_metadata(current_metadata, current_element)
        current_element.type.map do |type|
          next unless type_must_support_extension?(type.extension)

          metadata =
            {
              path: "#{current_metadata[:path].delete_suffix('[x]')}#{type.code.upcase_first}",
              original_path: current_metadata[:path]
            }
          metadata[:types] = [type.code] if save_type_code?(type)
          handle_type_must_support_target_profiles(type, metadata) if type.code == 'Reference'

          metadata
        end.compact
      end

      def handle_type_must_support_target_profiles(type, metadata)
        index = 0
        target_profiles = []

        type.source_hash['_targetProfile']&.each do |hash|
          if hash.present?
            element = FHIR::Element.new(hash)
            target_profiles << type.targetProfile[index] if type_must_support_extension?(element.extension)
          end
          index += 1
        end

        metadata[:target_profiles] = target_profiles if target_profiles.present?
      end

      def handle_choice_type_in_sliced_element(current_metadata, must_support_elements_metadata)
        choice_element_metadata = must_support_elements_metadata.find do |metadata|
          metadata[:original_path].present? &&
            current_metadata[:path].include?(metadata[:original_path])
        end

        return unless choice_element_metadata.present?

        current_metadata[:original_path] = current_metadata[:path]
        current_metadata[:path] =
          current_metadata[:path].sub(choice_element_metadata[:original_path], choice_element_metadata[:path])
      end

      def must_support_elements
        plain_must_support_elements.each_with_object([]) do |current_element, must_support_elements_metadata|
          {
            path: current_element.path.gsub("#{resource}.", '')
          }.tap do |current_metadata|
            current_metadata[:uscdi_only] = true if is_uscdi_requirement_element?(current_element)

            type_must_support_metadata = get_type_must_support_metadata(current_metadata, current_element)

            if type_must_support_metadata.any?
              must_support_elements_metadata.concat(type_must_support_metadata)
            else
              handle_choice_type_in_sliced_element(current_metadata, must_support_elements_metadata)

              supported_types = current_element.type.select { |type| save_type_code?(type) }.map(&:code)
              current_metadata[:types] = supported_types if supported_types.present?

              if current_element.type.first&.code == 'Reference'
                handle_type_must_support_target_profiles(current_element.type.first,
                                                         current_metadata)
              end

              handle_fixed_values(current_metadata, current_element)

              must_support_elements_metadata.delete_if do |metadata|
                metadata[:path] == current_metadata[:path] && metadata[:fixed_value].blank?
              end

              must_support_elements_metadata << current_metadata
            end
          end
        end.uniq
      end

      #### SPECIAL CASE ####

      # def handle_special_cases

      #   add_must_support_choices
      #   remove_observation_data_absent_reason

      # end

      # ONC and US Core 4.0.0 both clarified that health IT developers that
      # always provide HL7 FHIR "observation" values are not required to
      # demonstrate Health IT Module support for "dataAbsentReason" elements.
      # Remove MS check for dataAbsentReason and component.dataAbsentReason from
      # vital sign profiles and observation lab profile Smoking status profile
      # does not have MS on dataAbsentReason. It is safe to use profile.type ==
      # 'Observation'
      # def remove_observation_data_absent_reason
      #   return unless profile.type == 'Observation'

      #   @must_supports[:elements].delete_if do |element|
      #     ['dataAbsentReason', 'component.dataAbsentReason'].include?(element[:path])
      #   end
      # end
    end
  end
end
