require_relative 'naming'

module DaVinciUSDrugFormularyTestKit
  class Generator
    class SuiteGenerator
      class << self
        def generate(ig_metadata, base_output_dir)
          new(ig_metadata, base_output_dir).generate
        end
      end

      attr_accessor :ig_metadata, :base_output_dir

      def initialize(ig_metadata, base_output_dir)
        self.ig_metadata = ig_metadata
        self.base_output_dir = base_output_dir
      end

      def version_specific_message_filters
        []
      end

      def template
        @template ||= File.read(File.join(__dir__, 'templates', 'suite.rb.erb'))
      end

      def output
        @output ||= ERB.new(template).result(binding)
      end

      def base_output_file_name
        'usdf_test_suite.rb'
      end

      def class_name
        'USDFTestSuite'
      end

      def module_name
        "USDF#{ig_metadata.reformatted_version.upcase}"
      end

      def output_file_name
        File.join(base_output_dir, base_output_file_name)
      end

      def suite_id
        "davinci_us_drug_formulary_#{ig_metadata.reformatted_version}"
      end

      def title
        "DaVinci US Drug Formulary #{ig_metadata.ig_version}"
      end

      def short_title
        "US Drug Formulary #{ig_metadata.ig_version}"
      end

      def validator_env_name
        "#{ig_metadata.reformatted_version.upcase}_VALIDATOR_URL"
      end

      def ig_link
        'https://hl7.org/fhir/us/davinci-drug-formulary/STU2.0.1/'
      end

      def generate
        File.write(output_file_name, output)
      end

      def groups
        ig_metadata.ordered_groups
      end

      def group_id_list
        @group_id_list ||=
          groups.map(&:id)
      end

      def group_file_list
        @group_file_list ||=
          groups.map { |group| group.file_name.delete_suffix('.rb') }
      end

      def capability_statement_file_name
        "../../custom_groups/#{ig_metadata.ig_version}/capability_statement_group"
      end

      def capability_statement_group_id
        "usdf_#{ig_metadata.reformatted_version}_capability_statement"
      end
    end
  end
end
