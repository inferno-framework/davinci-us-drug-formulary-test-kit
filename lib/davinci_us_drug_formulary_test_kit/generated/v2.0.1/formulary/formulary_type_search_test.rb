require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciUSDrugFormularyTestKit
  module DaVinciUSDrugFormularyV201
    class FormularyTypeSearchTest < Inferno::Test
      include DaVinciUSDrugFormularyTestKit::SearchTest

      title 'Server supports Formulary search by type code DRUGPOL'
      description %(
This test verifies the server's ability to identify drug formularies using the required 'type' search parameter.
The server SHALL support searching InsurancePlan resources by type to enable clients to find formularies
that specifically represent drug policies.

The type search parameter ensures that InsurancePlan.type.coding.code is set to "DRUGPOL", a core requirement for 
formulary resources.

This search capability is essential for:
* Distinguishing drug formularies from other types of insurance plans
* Ensuring consistent identification of formulary resources
* Supporting reliable formulary discovery
* Enabling systematic formulary data access

The test will pass if matching resources are returned and properly implement the required DRUGPOL type code.
If no matching resources are found, the test is skipped.

[US Drug Formulary Server CapabilityStatement](http://hl7.org/fhir/us/davinci-drug-formulary/STU2/CapabilityStatement-usdf-server.html)

      )

      id :usdf_v201_formulary_type_search_test
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'InsurancePlan',
          search_param_names: ['type'],
          token_search_params: ['type']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:formulary_resources] ||= {}
      end

      run do
        run_search_test 
      end
    end
  end
end
