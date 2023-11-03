require_relative '../../../read_test'

module DaVinciUSDrugFormularyTestKit
  module USDFV200
    class BasicReadTest < Inferno::Test
      include DaVinciUSDrugFormularyTestKit::ReadTest

      title 'Server returns correct Basic resource from Basic read interaction'
      description 'A server SHALL support the Basic read interaction.'

      id :usdf_v200_basic_read_test

      def resource_type
        'Basic'
      end

      def scratch_resources
        scratch[:basic_resources] ||= {}
      end

      run do
        perform_read_test(all_scratch_resources)
      end
    end
  end
end
