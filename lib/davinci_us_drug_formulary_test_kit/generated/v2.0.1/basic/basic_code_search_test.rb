require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciUSDrugFormularyTestKit
  module DaVinciUSDrugFormularyV201
    class BasicCodeSearchTest < Inferno::Test
      include DaVinciUSDrugFormularyTestKit::SearchTest

      title 'Server supports Basic resource search by code for FormularyItem identification'
      description %(
This test verifies that the server can properly identify FormularyItem resources using the required 'code' search parameter. 
The server SHALL support searching Basic resources by code, specifically to find resources with code='formulary-item' that 
represent drug entries within a formulary.

This search is fundamental to:
* Identifying Basic resources that specifically represent formulary items
* Distinguishing FormularyItem resources from other Basic resource uses
* Enabling clients to find all drug entries within formularies

Because this is the first search of the sequence, resources in the
response will be used for subsequent tests.

Additionally, this test will check that GET and POST search methods
return the same number of results. Search by POST is required by the
FHIR R4 specification, and these tests interpret search by GET as a
requirement of US Core v2.0.1.

[US Drug Formulary Server CapabilityStatement](http://hl7.org/fhir/us/davinci-drug-formulary/STU2/CapabilityStatement-usdf-server.html)

      )

      id :usdf_v201_basic_code_search_test
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          first_search: true,
          fixed_value_search: true,
          resource_type: 'Basic',
          search_param_names: ['code'],
          token_search_params: ['code'],
          test_post_search: true
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
