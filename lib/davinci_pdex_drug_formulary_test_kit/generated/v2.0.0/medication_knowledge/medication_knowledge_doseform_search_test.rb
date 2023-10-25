require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXDrugFormularyTestKit
  module DaVinciPDEXDrugFormularyV200
    class MedicationKnowledgeDoseformSearchTest < Inferno::Test
      include DaVinciPDEXDrugFormularyTestKit::SearchTest

      title 'Server returns valid results for MedicationKnowledge search by doseform'
      description %(
A server SHOULD support searching by
doseform on the MedicationKnowledge resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Drug Formulary](http://hl7.org/fhir/us/davinci-drug-formulary//CapabilityStatement-usdf-server.html)

      )

      id :us_core_v200_medication_knowledge_doseform_search_test
      optional
  
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'MedicationKnowledge',
          search_param_names: ['doseform'],
          token_search_params: ['doseform']
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
