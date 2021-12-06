require_relative '../../validation_test'

module USCore
  class GoalValidationTest < Inferno::Test
    include USCore::ValidationTest

    title 'Goal resources returned during previous tests conform to the US Core Goal Profile'
    description %(
This test verifies resources returned from the first search conform to
the [US Core Goal Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-goal).

It verifies the presence of mandatory elements and that elements with
required bindings contain appropriate values. CodeableConcept element
bindings will fail if none of their codings have a code/system belonging
to the bound ValueSet. Quantity, Coding, and code element bindings will
fail if their code/system are not found in the valueset.

    )

    id :us_core_311_goal_validation_test

    def resource_type
      'Goal'
    end

    def scratch_resources
      scratch[:goal_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [], 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-goal')
    end
  end
end
