require_relative '../../search_test'

module USCore
  class ProcedureCodeSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for Procedure search by code'
    description %(
      A server MAY support searching by code on the Procedure resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :procedure_code_search_test

    def resource_type
      'Procedure'
    end

    def scratch_resources
      scratch[:procedure_resources] = [] if scratch[:procedure_resources].nil?
      scratch[:procedure_resources]
    end

    def search_params
      {
        'code': search_param_value(find_a_value_at(scratch_resources, 'code'))
      }
    end

    run do
      perform_search_test
    end
  end
end
