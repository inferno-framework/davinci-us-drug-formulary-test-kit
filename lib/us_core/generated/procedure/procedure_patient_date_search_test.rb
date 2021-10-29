require_relative '../../search_test'

module USCore
  class ProcedurePatientDateSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Procedure search by patient + date'
    description %(
      A server SHALL support searching by patient + date on the Procedure resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :procedure_patient_date_search_test

    input :patient_id, default: '85'

    def resource_type
      'Procedure'
    end

    def scratch_resources
      scratch[:procedure_resources] = [] if scratch[:procedure_resources].nil?
      scratch[:procedure_resources]
    end

    def search_params
      {
        'patient': patient_id,
        'date': search_param_value(find_a_value_at(scratch_resources, 'performed'))
      }
    end

    run do
      perform_search_test
    end
  end
end
