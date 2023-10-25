require_relative 'basic/basic_code_search_test'
require_relative 'basic/basic_id_search_test'
require_relative 'basic/basic_lastupdated_search_test'
require_relative 'basic/basic_subject_search_test'
require_relative 'basic/basic_status_search_test'
require_relative 'basic/basic_period_search_test'
require_relative 'basic/basic_formulary_search_test'
require_relative 'basic/basic_pharmacy_benefit_type_search_test'
require_relative 'basic/basic_drug_tier_search_test'
require_relative 'basic/basic_read_test'
require_relative 'basic/basic_subject_include_search_test'
require_relative 'basic/basic_formulary_include_search_test'
require_relative 'basic/basic_must_support_test'

module DaVinciPDEXDrugFormularyTestKit
  module USDFV200
    class BasicGroup < Inferno::TestGroup
      title 'Formulary Item Tests'
      short_description 'Verify support for the server capabilities required by the Formulary Item.'
      description %(
# Background

The USDF Formulary Item sequence verifies that the system under test is
able to provide correct responses for Basic queries. These queries
must contain resources conforming to the Formulary Item as
specified in the USDF v2.0.0 Implementation Guide.

# Testing Methodology
## Searching
This test sequence will first perform each required search associated
with this resource. This sequence will perform searches with the
following parameters:

* code
* _id
* _lastUpdated
* subject
* status
* period
* formulary
* pharmacy-benefit-type
* drug-tier

### Search Parameters
The first search uses the selected resources from the prior launch
sequence. Any subsequent searches will look for its parameter values
from the results of the first search. If a value cannot be found this way, the search is skipped.

### Search Validation
Inferno will retrieve up to the first 20 bundle pages of the reply for
Basic resources and save them for subsequent tests. Each of
these resources is then checked to see if it matches the searched
parameters in accordance with [FHIR search
guidelines](https://www.hl7.org/fhir/search.html).


## Must Support
Each profile contains elements marked as "must support". This test
sequence expects to see each of these elements at least once. If at
least one cannot be found, the test will fail. The test will look
through the Basic resources found in the first test for these
elements.

## Profile Validation
Each resource returned from the first search is expected to conform to
the [Formulary Item](http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-FormularyItem). Each element is checked against
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

      id :usdf_v200_basic
      run_as_group

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'basic', 'metadata.yml'), aliases: true))
      end
  
      test from: :us_core_v200_basic_code_search_test
      test from: :us_core_v200_basic__id_search_test
      test from: :us_core_v200_basic__lastUpdated_search_test
      test from: :us_core_v200_basic_subject_search_test
      test from: :us_core_v200_basic_status_search_test
      test from: :us_core_v200_basic_period_search_test
      test from: :us_core_v200_basic_formulary_search_test
      test from: :us_core_v200_basic_pharmacy_benefit_type_search_test
      test from: :us_core_v200_basic_drug_tier_search_test
      test from: :usdf_v200_basic_read_test
      test from: :usdf_v200_basic_subject_include_search_test
      test from: :usdf_v200_basic_formulary_include_search_test
      test from: :us_core_v200_basic_must_support_test
    end
  end
end
