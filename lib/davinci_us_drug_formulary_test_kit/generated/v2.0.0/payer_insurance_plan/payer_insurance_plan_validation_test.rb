require_relative '../../../validation_test'

module DaVinciUSDrugFormularyTestKit
  module DaVinciUSDrugFormularyV200
    class PayerInsurancePlanValidationTest < Inferno::Test
      include DaVinciUSDrugFormularyTestKit::ValidationTest

      id :usdf_v200_payer_insurance_plan_validation_test
      title 'InsurancePlan resources returned during previous tests conform to the Payer Insurance Plan profile'
      description %(
This test verifies resources returned from the first search conform to
the [Payer Insurance Plan profile](http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-PayerInsurancePlan).

Systems must demonstrate at least one valid example in order to pass this test.
It verifies the presence of mandatory elements and that elements with
required bindings contain appropriate values. CodeableConcept element
bindings will fail if none of their codings have a code/system belonging
to the bound ValueSet. Quantity, Coding, and code element bindings will
fail if their code/system are not found in the valueset.

      )
      output :dar_code_found, :dar_extension_found

      def resource_type
        'InsurancePlan'
      end

      def scratch_resources
        scratch[:payer_insurance_plan_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-PayerInsurancePlan',
                                '2.0.0')
      end
    end
  end
end
