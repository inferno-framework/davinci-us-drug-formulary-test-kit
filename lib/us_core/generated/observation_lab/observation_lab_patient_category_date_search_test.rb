require_relative '../../search_test'

module USCore
  class ObservationLabPatientCategoryDateSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Observation search by patient + category + date'
    description %(
      A server SHALL support searching by patient + category + date on the Observation resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :observation_lab_patient_category_date_search_test

    input :patient_id, default: '85'

    def resource_type
      'Observation'
    end

    def scratch_resources
      scratch[:observation_lab_resources] = [] if scratch[:observation_lab_resources].nil?
      scratch[:observation_lab_resources]
    end

    def search_params
      {
        'patient': patient_id,
        'category': search_param_value(find_a_value_at(scratch_resources, 'category')),
        'date': search_param_value(find_a_value_at(scratch_resources, 'effective'))
      }
    end

    run do
      perform_search_test
    end
  end
end
