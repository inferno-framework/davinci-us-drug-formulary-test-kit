require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciUSDrugFormularyTestKit
  module DaVinciUSDrugFormularyV201
    class BasicPharmacyBenefitTypeSearchTest < Inferno::Test
      include DaVinciUSDrugFormularyTestKit::SearchTest

      title 'Server supports FormularyItem search by pharmacy benefit type and network status'
      description %(
This test verifies the server's ability to search FormularyItem resources by their pharmacy benefit type using the required 'pharmacy-benefit-type' search parameter.
The server SHALL support searching Basic resources by pharmacy-benefit-type to enable clients to find formulary items based on their pharmacy network and duration characteristics.

The pharmacy-benefit-type search parameter maps to the usdf-PharmacyBenefitType-extension and supports the following values:
* 1-month-in-retail: One month supply at in-network retail pharmacy
* 1-month-out-retail: One month supply at out-of-network retail pharmacy
* 1-month-in-mail: One month supply at in-network mail order pharmacy
* 1-month-out-mail: One month supply at out-of-network mail order pharmacy
* 3-month-in-retail: Three month supply at in-network retail pharmacy
* 3-month-out-retail: Three month supply at out-of-network retail pharmacy
* 3-month-in-mail: Three month supply at in-network mail order pharmacy
* 3-month-out-mail: Three month supply at out-of-network mail order pharmacy

This search capability is essential for:
* Finding drugs available through specific pharmacy types (retail vs mail order)
* Determining network status impact on drug coverage
* Comparing costs across different supply durations and pharmacy types
* Supporting pharmacy network and supply duration-based drug selection

The test will pass if matching resources are returned and correctly implement the pharmacy benefit type extension.
If no matching resources are found, the test is skipped.

[US Drug Formulary Server CapabilityStatement](http://hl7.org/fhir/us/davinci-drug-formulary/STU2/CapabilityStatement-usdf-server.html)

      )

      id :usdf_v201_basic_pharmacy_benefit_type_search_test
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'Basic',
          search_param_names: ['pharmacy-benefit-type'],
          token_search_params: ['pharmacy-benefit-type']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:basic_resources] ||= {}
      end

      run do
        run_search_test 
      end
    end
  end
end
