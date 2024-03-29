require_relative 'naming'

module DaVinciUSDrugFormularyTestKit
  class Generator
    class ReferenceResolutionTestGenerator
      class << self
        def generate(ig_metadata, base_output_dir)
          ig_metadata.groups
            .each { |group| new(group, base_output_dir).generate }
        end
      end

      attr_accessor :group_metadata, :base_output_dir

      def initialize(group_metadata, base_output_dir)
        self.group_metadata = group_metadata
        self.base_output_dir = base_output_dir
      end

      def template
        @template ||= File.read(File.join(__dir__, 'templates', 'reference_resolution.rb.erb'))
      end

      def output
        @output ||= ERB.new(template).result(binding)
      end

      def base_output_file_name
        "#{class_name.underscore}.rb"
      end

      def output_file_directory
        File.join(base_output_dir, profile_identifier)
      end

      def output_file_name
        File.join(output_file_directory, base_output_file_name)
      end

      def profile_identifier
        Naming.snake_case_for_profile(group_metadata)
      end

      def test_id
        "usdf_#{group_metadata.reformatted_version}_#{profile_identifier}_reference_resolution_test"
      end

      def class_name
        "#{Naming.upper_camel_case_for_profile(group_metadata)}ReferenceResolutionTest"
      end

      def module_name
        "DaVinciUSDrugFormulary#{group_metadata.reformatted_version.upcase}"
      end

      def resource_type
        group_metadata.resource
      end

      def resource_collection_string
        'scratch_resources[:all]'
      end

      def must_support_references
        group_metadata.must_supports[:references]
      end

      def must_support_reference_list_string
        must_support_references
          .map { |element| "#{' ' * 8}* #{resource_type}.#{element[:path]}" }
          .map do |string|
            string
              .gsub(".where(url='http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/", ':')
              .gsub("')", '')
          end.uniq.sort.join("\n")
      end

      def generate
        return if must_support_references.empty?

        FileUtils.mkdir_p(output_file_directory)
        File.write(output_file_name, output)

        group_metadata.add_test(
          id: test_id,
          file_name: base_output_file_name
        )
      end
    end
  end
end
