require_relative '../../search_test'

module USCore
  class DiagnosticReportLabDateSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for DiagnosticReport search by date'
    description %(
      A server MAY support searching by date on the DiagnosticReport resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :diagnostic_report_lab_date_search_test

    def resource_type
      'DiagnosticReport'
    end

    def scratch_resources
      scratch[:diagnostic_report_lab_resources] = [] if scratch[:diagnostic_report_lab_resources].nil?
      scratch[:diagnostic_report_lab_resources]
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
