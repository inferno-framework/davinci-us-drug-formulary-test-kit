require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciUSDrugFormularyTestKit
  module DaVinciUSDrugFormularyV201
    class MedicationKnowledgeCodeSearchTest < Inferno::Test
      include DaVinciUSDrugFormularyTestKit::SearchTest

      title 'Server supports FormularyDrug search by RxNorm codes and form groups'
      description %(
This test verifies the server's ability to search FormularyDrug resources by RxNorm codes using the required 'code' search parameter.
The server SHALL support searching MedicationKnowledge resources by code to enable clients to find drugs using standardized RxNorm terminology.

The code search parameter validates that resources include:
* Primary RxNorm codes with Term Types (TTY):
  - SCD (Semantic Clinical Drug)
  - SBD (Semantic Branded Drug)
  - GPCK (Generic Pack)
  - BPCK (Branded Pack)

* Required form group codes when applicable:
  - SCDG (Semantic Clinical Drug Form Group) for SCD primary codes
  - SBDG (Semantic Branded Drug Form Group) for SBD primary codes

In addition to the above codes, there are several codes listed in the value
set expansions. 

This search capability is essential for:
* Finding specific drugs using standardized RxNorm identifiers
* Locating all strength variations of a drug using form group codes
* Supporting drug selection across equivalent clinical forms
* Enabling systematic drug coverage analysis

The test will pass if matching resources are returned and properly implement the required RxNorm code slices.
If no matching resources are found, the test is skipped.

[US Drug Formulary Server CapabilityStatement](http://hl7.org/fhir/us/davinci-drug-formulary/STU2/CapabilityStatement-usdf-server.html)

      )

      id :usdf_v201_medication_knowledge_code_search_test
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'MedicationKnowledge',
          search_param_names: ['code'],
          token_search_params: ['code']
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
