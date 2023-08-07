require_relative '../../../read_test'

module DaVinciPDEXDrugFormularyTestKit
  module USCoreV200
    class InsurancePlanReadTest < Inferno::Test
      include DaVinciPDEXDrugFormularyTestKit::ReadTest

      title 'Server returns correct InsurancePlan resource from InsurancePlan read interaction'
      description 'A server SHALL support the InsurancePlan read interaction.'

      id :us_core_v200_insurance_plan_read_test

      def resource_type
        'InsurancePlan'
      end

      def scratch_resources
        scratch[:insurance_plan_resources] ||= {}
      end

      run do
        perform_read_test(all_scratch_resources)
      end
    end
  end
end
