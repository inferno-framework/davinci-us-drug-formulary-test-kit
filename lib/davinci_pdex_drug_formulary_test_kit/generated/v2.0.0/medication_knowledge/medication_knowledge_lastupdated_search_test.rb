require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXDrugFormularyTestKit
  module USCoreV200
    class MedicationKnowledgeLastupdatedSearchTest < Inferno::Test
      include DaVinciPDEXDrugFormularyTestKit::SearchTest

      title 'Server returns valid results for MedicationKnowledge search by _lastUpdated'
      description %(
A server SHALL support searching by
_lastUpdated on the MedicationKnowledge resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Drug Formulary](http://hl7.org/fhir/us/davinci-drug-formulary//CapabilityStatement-usdf-server.html)

      )

      id :us_core_v200_medication_knowledge__lastUpdated_search_test
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'MedicationKnowledge',
        search_param_names: ['_lastUpdated']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:medication_knowledge_resources] ||= {}
      end

      run do
        run_search_test 
      end
    end
  end
end
