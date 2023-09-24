require_relative 'payer_insurance_plan/payer_insurance_plan_status_search_test'
require_relative 'payer_insurance_plan/payer_insurance_plan_id_search_test'
require_relative 'payer_insurance_plan/payer_insurance_plan_lastupdated_search_test'
require_relative 'payer_insurance_plan/payer_insurance_plan_identifier_search_test'
require_relative 'payer_insurance_plan/payer_insurance_plan_period_search_test'
require_relative 'payer_insurance_plan/payer_insurance_plan_type_search_test'
require_relative 'payer_insurance_plan/payer_insurance_plan_name_search_test'
require_relative 'payer_insurance_plan/payer_insurance_plan_coverage_type_search_test'
require_relative 'payer_insurance_plan/payer_insurance_plan_formulary_coverage_search_test'
require_relative 'payer_insurance_plan/payer_insurance_plan_coverage_area_search_test'
require_relative 'payer_insurance_plan/payer_insurance_plan_read_test'

module DaVinciPDEXDrugFormularyTestKit
  module USDFV200
    class PayerInsurancePlanGroup < Inferno::TestGroup
      title 'Payer Insurance Plan Tests'
      short_description 'Verify support for the server capabilities required by the Payer Insurance Plan.'
      description %(
# Background

The USDF Payer Insurance Plan sequence verifies that the system under test is
able to provide correct responses for InsurancePlan queries. These queries
must contain resources conforming to the Payer Insurance Plan as
specified in the USDF v2.0.0 Implementation Guide.

# Testing Methodology
## Searching
This test sequence will first perform each required search associated
with this resource. This sequence will perform searches with the
following parameters:

* status
* _id
* _lastUpdated
* identifier
* period
* type
* name
* coverage-type
* formulary-coverage
* coverage-area

### Search Parameters
The first search uses the selected resources from the prior launch
sequence. Any subsequent searches will look for its parameter values
from the results of the first search. If a value cannot be found this way, the search is skipped.

### Search Validation
Inferno will retrieve up to the first 20 bundle pages of the reply for
InsurancePlan resources and save them for subsequent tests. Each of
these resources is then checked to see if it matches the searched
parameters in accordance with [FHIR search
guidelines](https://www.hl7.org/fhir/search.html).


## Must Support
Each profile contains elements marked as "must support". This test
sequence expects to see each of these elements at least once. If at
least one cannot be found, the test will fail. The test will look
through the InsurancePlan resources found in the first test for these
elements.

## Profile Validation
Each resource returned from the first search is expected to conform to
the [Payer Insurance Plan](http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-PayerInsurancePlan). Each element is checked against
teminology binding and cardinality requirements.

Elements with a required binding are validated against their bound
ValueSet. If the code/system in the element is not part of the ValueSet,
then the test will fail.

## Reference Validation
At least one instance of each external reference in elements marked as
"must support" within the resources provided by the system must resolve.
The test will attempt to read each reference found and will fail if no
read succeeds.

      )

      id :usdf_v200_payer_insurance_plan
      run_as_group

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'payer_insurance_plan', 'metadata.yml'), aliases: true))
      end
  
      test from: :us_core_v200_payer_insurance_plan_status_search_test
      test from: :us_core_v200_payer_insurance_plan__id_search_test
      test from: :us_core_v200_payer_insurance_plan__lastUpdated_search_test
      test from: :us_core_v200_payer_insurance_plan_identifier_search_test
      test from: :us_core_v200_payer_insurance_plan_period_search_test
      test from: :us_core_v200_payer_insurance_plan_type_search_test
      test from: :us_core_v200_payer_insurance_plan_name_search_test
      test from: :us_core_v200_payer_insurance_plan_coverage_type_search_test
      test from: :us_core_v200_payer_insurance_plan_formulary_coverage_search_test
      test from: :us_core_v200_payer_insurance_plan_coverage_area_search_test
      test from: :usdf_v200_payer_insurance_plan_read_test
    end
  end
end
