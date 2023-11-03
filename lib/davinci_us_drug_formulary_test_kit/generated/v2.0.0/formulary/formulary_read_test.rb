require_relative '../../../read_test'

module DaVinciUSDrugFormularyTestKit
  module USDFV200
    class FormularyReadTest < Inferno::Test
      include DaVinciUSDrugFormularyTestKit::ReadTest

      title 'Server returns correct InsurancePlan resource from InsurancePlan read interaction'
      description 'A server SHALL support the InsurancePlan read interaction.'

      id :usdf_v200_formulary_read_test

      def resource_type
        'InsurancePlan'
      end

      def scratch_resources
        scratch[:formulary_resources] ||= {}
      end

      run do
        perform_read_test(all_scratch_resources)
      end
    end
  end
end
