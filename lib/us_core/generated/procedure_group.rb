require_relative 'procedure/procedure_patient_search_test'
require_relative 'procedure/procedure_patient_date_search_test'
require_relative 'procedure/procedure_patient_status_search_test'
require_relative 'procedure/procedure_patient_code_date_search_test'
require_relative 'procedure/procedure_read_test'
require_relative 'procedure/procedure_provenance_revinclude_search_test'
require_relative 'procedure/procedure_validation_test'
require_relative 'procedure/procedure_must_support_test'
require_relative 'procedure/procedure_reference_resolution_test'

module USCore
  class ProcedureGroup < Inferno::TestGroup
    title 'Procedure Tests'
    # description ''

    id :procedure

    test from: :procedure_patient_search_test
    test from: :procedure_patient_date_search_test
    test from: :procedure_patient_status_search_test
    test from: :procedure_patient_code_date_search_test
    test from: :procedure_read_test
    test from: :procedure_provenance_revinclude_search_test
    test from: :procedure_validation_test
    test from: :procedure_must_support_test
    test from: :procedure_reference_resolution_test
  end
end
