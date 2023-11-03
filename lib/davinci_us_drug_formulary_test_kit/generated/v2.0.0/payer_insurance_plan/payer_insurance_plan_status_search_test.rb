require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciUSDrugFormularyTestKit
  module DaVinciUSDrugFormularyV200
    class PayerInsurancePlanStatusSearchTest < Inferno::Test
      include DaVinciUSDrugFormularyTestKit::SearchTest

      title 'Server returns valid results for InsurancePlan search by status'
      description %(
A server SHALL support searching by
status on the InsurancePlan resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

Because this is the first search of the sequence, resources in the
response will be used for subsequent tests.

Additionally, this test will check that GET and POST search methods
return the same number of results. Search by POST is required by the
FHIR R4 specification, and these tests interpret search by GET as a
requirement of US Core v2.0.0.

[US Drug Formulary](http://hl7.org/fhir/us/davinci-drug-formulary/STU2/CapabilityStatement-usdf-server.html)

      )

      id :usdf_v200_payer_insurance_plan_status_search_test
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          first_search: true,
          fixed_value_search: true,
          resource_type: 'InsurancePlan',
          search_param_names: ['status'],
          test_post_search: true
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:payer_insurance_plan_resources] ||= {}
      end

      run do
        run_search_test 
      end
    end
  end
end
