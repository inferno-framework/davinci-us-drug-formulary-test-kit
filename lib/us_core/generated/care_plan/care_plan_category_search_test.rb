require_relative '../../search_test'

module USCore
  class CarePlanCategorySearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for CarePlan search by category'
    description %(
      A server MAY support searching by category on the CarePlan resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :care_plan_category_search_test

    def resource_type
      'CarePlan'
    end

    def scratch_resources
      scratch[:care_plan_resources] = [] if scratch[:care_plan_resources].nil?
      scratch[:care_plan_resources]
    end

    def search_params
      {
        'category': search_param_value(find_a_value_at(scratch_resources, 'category'))
      }
    end

    run do
      perform_search_test
    end
  end
end
