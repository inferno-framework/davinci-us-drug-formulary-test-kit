require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciUSDrugFormularyTestKit
  module DaVinciUSDrugFormularyV201
    class BasicBasicSubjectIncludeSearchTest < Inferno::Test
      include DaVinciUSDrugFormularyTestKit::SearchTest

      title 'Server returns MedicationKnowledge resources from Basic search by _include=Basic:subject'
      description %(
        A server SHALL be capable of supporting _includes for Basic:subject.

        This test will perform a search using _include=Basic:subject and
        will pass if the referenced MedicationKnowledge is included in the response.
      )

      id :usdf_v201_basic_basic_subject_include_search_test

      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'Basic',
          search_param_names: ["code"],
          include_param: 'Basic:subject'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.include_metadata
        @include_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'MedicationKnowledge', 'metadata.yml'), aliases: true))
      end

      run do
        run_include_search_test
      end
    end
  end
end
