require_relative '../../search_test'

module USCore
  class MedicationRequestIntentSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for MedicationRequest search by intent'
    description %(
      A server MAY support searching by intent on the MedicationRequest resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :medication_request_intent_search_test

    def resource_type
      'MedicationRequest'
    end

    def scratch_resources
      scratch[:medication_request_resources] = [] if scratch[:medication_request_resources].nil?
      scratch[:medication_request_resources]
    end

    def search_params
      {
        'intent': search_param_value(find_a_value_at(scratch_resources, 'intent'))
      }
    end

    run do
      perform_search_test
    end
  end
end
