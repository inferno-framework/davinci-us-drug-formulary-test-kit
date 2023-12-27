require 'inferno/dsl/oauth_credentials'
require_relative '../../version'
require_relative '../../custom_groups/v2.0.0/capability_statement_group'
require_relative 'payer_insurance_plan_group'
require_relative 'formulary_group'
require_relative 'basic_group'
require_relative 'medication_knowledge_group'
require_relative 'location_group'

module DaVinciUSDrugFormularyTestKit
  module USDFV200
    class USDFTestSuite < Inferno::TestSuite
      title 'Da Vinci US Drug Formulary v2.0.0'
      short_title 'US Drug Formulary v2.0.0'
      description %(
        The Da Vinci US Drug Formulary Test Kit tests systems for their
        conformance to the [US Drug Formulary Implementation Guide](https://hl7.org/fhir/us/davinci-drug-formulary/STU2/).

        ## Instructions
        In order to run the tests, provide the base URL of the FHIR server to
        test, along with the IDs of Insurance Plan Location resources.
        Credentials may optionally be provided if testing against a system which
        requires authorization.

        ## Scope
        These tests check the following behaviors as defined in the IG:
        - FHIR Interactions
          - Conformance
          - Read
          - Search
            - Individual search parameters
            - _include searches
        - FHIR Data
          - Validation against IG profiles
          - Presence of all Must Support fields
            - Resolution of Must Support references

        **Known Issues**
        - Must Support checks are not performed for all elements of Formulary
          Drug resources due to the use of an intensional value set for slicing
          `MedicationKnowledge.code.coding` elements.
        - The following search features are not tested
          - Combination searches
          - Multiple Or
          - Multiple And
          - Comparators
      )
      version VERSION

      VALIDATION_MESSAGE_FILTERS = [
        %r{Sub-extension url 'introspect' is not defined by the Extension http://fhir-registry\.smarthealthit\.org/StructureDefinition/oauth-uris},
        %r{Sub-extension url 'revoke' is not defined by the Extension http://fhir-registry\.smarthealthit\.org/StructureDefinition/oauth-uris},
        /Observation\.effective\.ofType\(Period\): .*vs-1:/ # Invalid invariant in FHIR v4.0.1
      ].freeze

      VERSION_SPECIFIC_MESSAGE_FILTERS = [].freeze

      def self.metadata
        @metadata ||= YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true)[:groups].map do |raw_metadata|
            Generator::GroupMetadata.new(raw_metadata)
          end
      end

      validator do
        url ENV.fetch('V200_VALIDATOR_URL', 'http://validator_service:4567')
        message_filters = VALIDATION_MESSAGE_FILTERS + VERSION_SPECIFIC_MESSAGE_FILTERS

        exclude_message do |message|

          message_filters.any? { |filter| filter.match? message.message }
        end

        perform_additional_validation do |resource, profile_url|
          ProvenanceValidator.validate(resource) if resource.instance_of?(FHIR::Provenance)
        end
      end

      id :usdf_v200

      input :url,
        title: 'FHIR Endpoint',
        description: 'URL of the FHIR endpoint'
      input :smart_credentials,
        title: 'OAuth Credentials',
        type: :oauth_credentials,
        optional: true

      fhir_client do
        url :url
        oauth_credentials :smart_credentials
      end

      group from: :usdf_v200_capability_statement
  
      group from: :usdf_v200_payer_insurance_plan
      group from: :usdf_v200_formulary
      group from: :usdf_v200_basic
      group from: :usdf_v200_medication_knowledge
      group from: :usdf_v200_location
    end
  end
end
