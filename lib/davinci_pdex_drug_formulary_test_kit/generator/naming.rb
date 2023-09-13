module DaVinciPDEXDrugFormularyTestKit
  class Generator
    module Naming
      ALLERGY_INTOLERANCE = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-allergyintolerance'.freeze
      CARE_PLAN = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-careplan'.freeze
      CARE_TEAM = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-careteam'.freeze
      CONDITION = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition'.freeze
      IMPLANTABLE_DEVICE = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-implantable-device'.freeze
      DIAGNOSTIC_REPORT_NOTE = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-note'.freeze
      DIAGNOSTIC_REPORT_LAB = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-lab'.freeze
      DOCUMENT_REFERENCE = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-documentreference'.freeze
      ENCOUNTER = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter'.freeze
      GOAL = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-goal'.freeze
      IMMUNIZATION = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-immunization'.freeze
      LOCATION = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-location'.freeze
      MEDICATION = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-medication'.freeze
      MEDICATION_REQUEST = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-medicationrequest'.freeze
      SMOKING_STATUS = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-smokingstatus'.freeze
      PEDIATRIC_WEIGHT_FOR_HEIGHT = 'http://hl7.org/fhir/us/core/StructureDefinition/pediatric-weight-for-height'.freeze
      OBSERVATION_LAB = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab'.freeze
      PEDIATRIC_BMI_FOR_AGE = 'http://hl7.org/fhir/us/core/StructureDefinition/pediatric-bmi-for-age'.freeze
      PULSE_OXIMETRY = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-pulse-oximetry'.freeze
      HEAD_CIRCUMFERENCE = 'http://hl7.org/fhir/us/core/StructureDefinition/head-occipital-frontal-circumference-percentile'.freeze
      ORGANIZATION = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-organization'.freeze
      PATIENT = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient'.freeze
      PRACTITIONER = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner'.freeze
      PRACTITIONER_ROLE = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitionerrole'.freeze
      PROCEDURE = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-procedure'.freeze
      PROVENANCE = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-provenance'.freeze

      class << self
        def resources_with_multiple_profiles
          ['InsurancePlan']
        end

        def resource_has_multiple_profiles?(resource)
          resources_with_multiple_profiles.include? resource
        end

        def snake_case_for_profile(group_metadata)
          resource = group_metadata.resource
          return resource.underscore unless resource_has_multiple_profiles?(resource)

          group_metadata.name
            .delete_prefix('usdf_')
            .underscore
        end

        def upper_camel_case_for_profile(group_metadata)
          snake_case_for_profile(group_metadata).camelize
        end
      end
    end
  end
end
