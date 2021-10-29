require_relative '../../search_test'

module USCore
  class SmokingstatusCategorySearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Observation search by category'
    description %(
      A server MAY support searching by category on the Observation resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :smokingstatus_category_search_test

    def resource_type
      'Observation'
    end

    def scratch_resources
      scratch[:smokingstatus_resources] = [] if scratch[:smokingstatus_resources].nil?
      scratch[:smokingstatus_resources]
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
