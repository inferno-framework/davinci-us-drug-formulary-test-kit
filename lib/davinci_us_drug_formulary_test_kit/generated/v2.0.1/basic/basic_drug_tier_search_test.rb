require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciUSDrugFormularyTestKit
  module DaVinciUSDrugFormularyV201
    class BasicDrugTierSearchTest < Inferno::Test
      include DaVinciUSDrugFormularyTestKit::SearchTest

      title 'Server supports FormularyItem search by drug tier classification'
      description %(
This test verifies the server's ability to search FormularyItem resources by their drug tier classification using the required 'drug-tier' search parameter.
The server SHALL support searching Basic resources by drug-tier to enable clients to find formulary items based on their cost-sharing tier.

The drug-tier search parameter maps to the usdf-DrugTierID-extension and supports the following values:
* generic
* preferred-generic
* non-preferred-generic
* specialty
* brand
* preferred-brand
* non-preferred-brand
* zero-cost-share-preventative
* medical-service

This search capability is essential for:
* Finding all drugs within a specific cost-sharing tier
* Enabling cost-based drug selection and comparison
* Supporting formulary analysis by tier structure

The test will pass if matching resources are returned and correctly implement the drug tier extension.
If no matching resources are found, the test is skipped.

[US Drug Formulary Server CapabilityStatement](http://hl7.org/fhir/us/davinci-drug-formulary/STU2/CapabilityStatement-usdf-server.html)

      )

      id :usdf_v201_basic_drug_tier_search_test
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'Basic',
          search_param_names: ['drug-tier'],
          token_search_params: ['drug-tier']
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
