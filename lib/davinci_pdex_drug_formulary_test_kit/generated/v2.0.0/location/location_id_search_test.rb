require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXDrugFormularyTestKit
  module DaVinciPDEXDrugFormularyV200
    class LocationIdSearchTest < Inferno::Test
      include DaVinciPDEXDrugFormularyTestKit::SearchTest

      title 'Server returns valid results for Location search by _id'
      description %(
A server SHALL support searching by
_id on the Location resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

Because this is the first search of the sequence, resources in the
response will be used for subsequent tests.

Additionally, this test will check that GET and POST search methods
return the same number of results. Search by POST is required by the
FHIR R4 specification, and these tests interpret search by GET as a
requirement of US Core v2.0.0.

[US Drug Formulary](http://hl7.org/fhir/us/davinci-drug-formulary//CapabilityStatement-usdf-server.html)

      )

      id :us_core_v200_location__id_search_test
  
      input :input_ids,
        title: 'Location IDs',
        description: 'Comma separated list of Location IDs that in sum contain all MUST SUPPORT elements'
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          first_search: true,
          resource_type: 'Location',
          search_param_names: ['_id'],
          test_post_search: true
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:location_resources] ||= {}
      end

      run do
        run_search_test 
      end
    end
  end
end
