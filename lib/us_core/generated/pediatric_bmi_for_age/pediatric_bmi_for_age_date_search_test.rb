require_relative '../../search_test'

module USCore
  class PediatricBmiForAgeDateSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Observation search by date'
    description %(
      A server MAY support searching by date on the Observation resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :pediatric_bmi_for_age_date_search_test

    def resource_type
      'Observation'
    end

    def scratch_resources
      scratch[:pediatric_bmi_for_age_resources] = [] if scratch[:pediatric_bmi_for_age_resources].nil?
      scratch[:pediatric_bmi_for_age_resources]
    end

    def search_params
      {
        'date': search_param_value(find_a_value_at(scratch_resources, 'effective'))
      }
    end

    run do
      perform_search_test
    end
  end
end
