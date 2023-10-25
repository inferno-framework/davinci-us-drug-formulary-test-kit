require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXDrugFormularyTestKit
  module DaVinciPDEXDrugFormularyV200
    class BasicSubjectIncludeSearchTest < Inferno::Test
      include DaVinciPDEXDrugFormularyTestKit::SearchTest

      title 'Server returns MedicationKnowledge resources from Basic search by _include=subject'
      description %(
        A server SHALL be capable of supporting _includes for subject.

        This test will perform a search using _include=subject and
        will pass if the referenced MedicationKnowledge is included in the response.
      )

      id :usdf_v200_basic_subject_include_search_test

      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'Basic',
          search_param_names: ["code"],
          include_param: 'subject'
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
