require_relative '../../search_test'

module USCore
  class PatientFamilySearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Patient search by family'
    description %(
      A server MAY support searching by family on the Patient resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :patient_family_search_test

    def resource_type
      'Patient'
    end

    def scratch_resources
      scratch[:patient_resources] = [] if scratch[:patient_resources].nil?
      scratch[:patient_resources]
    end

    def search_params
      {
        'family': search_param_value(find_a_value_at(scratch_resources, 'name.family'))
      }
    end

    run do
      perform_search_test
    end
  end
end
