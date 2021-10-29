require_relative '../../search_test'

module USCore
  class ConditionPatientCategorySearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Condition search by patient + category'
    description %(
      A server SHOULD support searching by patient + category on the Condition resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :condition_patient_category_search_test

    input :patient_id, default: '85'

    def resource_type
      'Condition'
    end

    def scratch_resources
      scratch[:condition_resources] = [] if scratch[:condition_resources].nil?
      scratch[:condition_resources]
    end

    def search_params
      {
        'patient': patient_id,
        'category': search_param_value(find_a_value_at(scratch_resources, 'category'))
      }
    end

    run do
      perform_search_test
    end
  end
end
