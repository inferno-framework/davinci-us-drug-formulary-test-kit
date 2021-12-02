require_relative 'head_circumference/head_circumference_patient_code_search_test'
require_relative 'head_circumference/head_circumference_patient_category_date_search_test'
require_relative 'head_circumference/head_circumference_patient_category_status_search_test'
require_relative 'head_circumference/head_circumference_patient_code_date_search_test'
require_relative 'head_circumference/head_circumference_patient_category_search_test'
require_relative 'head_circumference/head_circumference_read_test'
require_relative 'head_circumference/head_circumference_provenance_revinclude_search_test'
require_relative 'head_circumference/head_circumference_validation_test'
require_relative 'head_circumference/head_circumference_must_support_test'
require_relative 'head_circumference/head_circumference_reference_resolution_test'

module USCore
  class HeadCircumferenceGroup < Inferno::TestGroup
    title 'HeadCircumference Tests'
    # description ''

    id :head_circumference

    test from: :head_circumference_patient_code_search_test
    test from: :head_circumference_patient_category_date_search_test
    test from: :head_circumference_patient_category_status_search_test
    test from: :head_circumference_patient_code_date_search_test
    test from: :head_circumference_patient_category_search_test
    test from: :head_circumference_read_test
    test from: :head_circumference_provenance_revinclude_search_test
    test from: :head_circumference_validation_test
    test from: :head_circumference_must_support_test
    test from: :head_circumference_reference_resolution_test
  end
end
