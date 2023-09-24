require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXDrugFormularyTestKit
  module USCoreV200
    class BasicPharmacyBenefitTypeSearchTest < Inferno::Test
      include DaVinciPDEXDrugFormularyTestKit::SearchTest

      title 'Server returns valid results for Basic search by pharmacy-benefit-type'
      description %(
A server SHALL support searching by
pharmacy-benefit-type on the Basic resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Drug Formulary](http://hl7.org/fhir/us/davinci-drug-formulary//CapabilityStatement-usdf-server.html)

      )

      id :us_core_v200_basic_pharmacy_benefit_type_search_test
  
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
