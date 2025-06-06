require_relative '../../../validation_test'

module DaVinciUSDrugFormularyTestKit
  module DaVinciUSDrugFormularyV201
    class MedicationKnowledgeValidationTest < Inferno::Test
      include DaVinciUSDrugFormularyTestKit::ValidationTest

      id :usdf_v201_medication_knowledge_validation_test
      title 'MedicationKnowledge resources returned during previous tests conform to the Formulary Drug profile'
      description %(
This test verifies that MedicationKnowledge resources conform to the
[USDF FormularyDrug profile](http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-FormularyDrug).

The test validates:

Mandatory Elements:
* MedicationKnowledge.code - RxNorm drug codes
* MedicationKnowledge.code.coding - Required code slices
* MedicationKnowledge.code.coding.system - Must use RxNorm (http://www.nlm.nih.gov/research/umls/rxnorm)
* MedicationKnowledge.code.coding.code - Valid RxNorm concept
* MedicationKnowledge.status - Active/inactive status

The test will pass if at least one valid example is found that meets all profile requirements.
If validation errors occur, details will be provided to help identify non-conformant elements.

[USDF Implementation Guide](http://hl7.org/fhir/us/davinci-drug-formulary/STU2.0.1/)

      )
      output :dar_code_found, :dar_extension_found

      def resource_type
        'MedicationKnowledge'
      end

      def scratch_resources
        scratch[:medication_knowledge_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-FormularyDrug',
                                '2.0.1')
      end
    end
  end
end
