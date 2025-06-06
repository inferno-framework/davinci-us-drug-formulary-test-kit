require_relative '../../../validation_test'

module DaVinciUSDrugFormularyTestKit
  module DaVinciUSDrugFormularyV201
    class BasicValidationTest < Inferno::Test
      include DaVinciUSDrugFormularyTestKit::ValidationTest

      id :usdf_v201_basic_validation_test
      title 'Basic resources returned during previous tests conform to the Formulary Item profile'
      description %(
This test verifies that Basic resources representing formulary items conform to the
[USDF FormularyItem profile](http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-FormularyItem).

The test validates:

Mandatory Elements:
* Basic.extension - Required extensions for formulary data
* Basic.code - Must be set to "formulary-item"
* Basic.subject - Reference to the associated FormularyDrug

Required Extensions:
* usdf-FormularyReference-extension: Links to parent formulary
* usdf-AvailabilityStatus-extension: Drug's current status
* usdf-AvailabilityPeriod-extension: Time period for coverage
* usdf-PharmacyBenefitType-extension: Pharmacy network and duration
* usdf-DrugTierID-extension: Cost-sharing tier classification
* usdf-PriorAuthorization-extension: Prior auth requirements
* usdf-StepTherapyLimit-extension: Step therapy rules
* usdf-QuantityLimit-extension: Quantity restrictions

Value Set Bindings:
* Drug tier codes must come from DrugTierVS
* Pharmacy benefit types must come from PharmacyBenefitTypeVS
* Status values must come from PublicationStatusVS

The test will pass if at least one valid example is found that meets all profile requirements.
If validation errors occur, details will be provided to help identify non-conformant elements.

[USDF Implementation Guide](http://hl7.org/fhir/us/davinci-drug-formulary/STU2.0.1/)

      )
      output :dar_code_found, :dar_extension_found

      def resource_type
        'Basic'
      end

      def scratch_resources
        scratch[:basic_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-FormularyItem',
                                '2.0.1')
      end
    end
  end
end
