require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciUSDrugFormularyTestKit
  module DaVinciUSDrugFormularyV201
    class LocationAddressSearchTest < Inferno::Test
      include DaVinciUSDrugFormularyTestKit::SearchTest

      title 'Server supports InsurancePlanLocation search by address for formulary coverage areas'
      description %(
This test verifies the server's ability to search Location resources by address to define geographic coverage areas for formularies.
The server SHALL support searching Location resources by address to enable clients to determine where specific formularies apply.

The address search parameter is fundamental for:
* Defining geographic regions where formularies are valid
* Supporting location-based formulary lookup
* Complementing GeoJSON boundary definitions with structured address data
* Enabling address-based coverage area queries

Key aspects of address searching:
* Supports full address matching
* Works in conjunction with more specific parameters (city, state, postal code)

This search capability enables:
* Geographic-based formulary discovery
* Coverage area validation
* Service area boundary definition
* Location-specific formulary access

The test will pass if matching resources are returned and properly implement address elements.
If no matching resources are found, the test is skipped.

[US Drug Formulary Server CapabilityStatement](http://hl7.org/fhir/us/davinci-drug-formulary/STU2/CapabilityStatement-usdf-server.html)

      )

      id :usdf_v201_location_address_search_test
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'Location',
          search_param_names: ['address']
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
