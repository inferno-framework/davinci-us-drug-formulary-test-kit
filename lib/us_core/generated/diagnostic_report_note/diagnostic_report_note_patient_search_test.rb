require_relative '../../search_test'

module USCore
  class DiagnosticReportNotePatientSearchTest < Inferno::Test
    include USCore::SearchTest

    title 'Server returns valid results for DiagnosticReport search by patient'
    description %(
      A server SHALL support searching by patient on the DiagnosticReport resource. This
      test will pass if resources are returned and match the search criteria. If
      none are returned, the test is skipped'
    %)

    id :diagnostic_report_note_patient_search_test

    input :patient_id, default: '85'

    def resource_type
      'DiagnosticReport'
    end

    def scratch_resources
      scratch[:diagnostic_report_note_resources] = [] if scratch[:diagnostic_report_note_resources].nil?
      scratch[:diagnostic_report_note_resources]
    end

    def search_params
      {
        'patient': patient_id
      }
    end

    run do
      perform_search_test
    end
  end
end
