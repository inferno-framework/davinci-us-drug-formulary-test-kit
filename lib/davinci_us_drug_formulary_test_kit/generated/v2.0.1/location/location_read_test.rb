require_relative '../../../read_test'

module DaVinciUSDrugFormularyTestKit
  module USDFV201
    class LocationReadTest < Inferno::Test
      include DaVinciUSDrugFormularyTestKit::ReadTest

      title 'Server returns correct Location resource from Location read interaction'
      description 'A server SHALL support the Location read interaction.'

      id :usdf_v201_location_read_test

      def resource_type
        'Location'
      end

      def scratch_resources
        scratch[:location_resources] ||= {}
      end

      run do
        perform_read_test(all_scratch_resources)
      end
    end
  end
end
