require_relative 'basic/basic_read_test'

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
specified in the US Drug Formulary v2.0.0 Implementation
Guide.

# Testing Methodology


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
  
      test from: :usdf_v200_basic_read_test
    end
  end
end