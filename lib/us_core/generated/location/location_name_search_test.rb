require_relative '../../search_test'

module USCore
  class LocationNameSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Location search by name'
    description %(
      A server SHALL support searching by name on the Location resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :location_name_search_test

    def resource_type
      'Location'
    end

    def scratch_resources
      scratch[:location_resources] = [] if scratch[:location_resources].nil?
      scratch[:location_resources]
    end

    def search_params
      {
        'name': search_param_value(find_a_value_at(scratch_resources, 'name'))
      }
    end

    run do
      perform_search_test
    end
  end
end
