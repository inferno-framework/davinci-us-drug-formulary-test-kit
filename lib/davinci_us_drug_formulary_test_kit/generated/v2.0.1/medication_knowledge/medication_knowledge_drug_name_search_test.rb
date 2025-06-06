require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciUSDrugFormularyTestKit
  module DaVinciUSDrugFormularyV201
    class MedicationKnowledgeDrugNameSearchTest < Inferno::Test
      include DaVinciUSDrugFormularyTestKit::SearchTest

      title 'Server supports FormularyDrug search by drug names'
      description %(
This test verifies the server's ability to search FormularyDrug resources by drug names using the required 'drug-name' search parameter.
The server SHALL support searching MedicationKnowledge resources by drug-name to enable clients to find drugs using text-based names.

The drug-name search parameter searches across:
* code.coding.display: The RxNorm display names for both:
  - Specific drug codes (SCD/SBD/GPCK/BPCK)
  - Form group codes (SCDG/SBDG) where applicable
* synonym: Alternative names for the medication

Key aspects of drug name searching:
* Matches both branded and generic names
* Includes form group display names for broader matching
* Supports partial name matching for user-friendly search
* Returns all strength variations when searching by base name
* Includes synonyms to support various naming conventions

This search capability is essential for:
* User-friendly drug lookup by name
* Finding all variations of a drug across strengths
* Supporting both generic and branded name searches
* Accommodating different naming conventions through synonyms

The test will pass if matching resources are returned and properly implement the required name elements.
If no matching resources are found, the test is skipped.

[US Drug Formulary Server CapabilityStatement](http://hl7.org/fhir/us/davinci-drug-formulary/STU2/CapabilityStatement-usdf-server.html)

      )

      id :usdf_v201_medication_knowledge_drug_name_search_test
      optional
  
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'MedicationKnowledge',
          search_param_names: ['drug-name']
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
