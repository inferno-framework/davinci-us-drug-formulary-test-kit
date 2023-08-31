require 'tls_test_kit'
require_relative '../capability_statement/conformance_support_test'
require_relative '../capability_statement/fhir_version_test'
require_relative '../capability_statement/json_support_test'
require_relative '../capability_statement/profile_support_test'
require_relative '../capability_statement/instantiate_test.rb'

module DaVinciPDEXDrugFormularyTestKit
  module USDFV200
    class CapabilityStatementGroup < Inferno::TestGroup
      id :usdf_v200_capability_statement
      title 'Capability Statement'
      short_description 'Retrieve information about supported server functionality using the FHIR capabilties interaction.'
      description %(
        # Background
        The #{title} Sequence tests a FHIR server's ability to formally describe
        features supported by the API by using the [Capability
        Statement](https://www.hl7.org/fhir/capabilitystatement.html) resource.
        The features described in the Capability Statement must be consistent with
        the required capabilities of a US Drug Formulary. The Capability Statement
        must also advertise the location of the required SMART on FHIR endpoints
        that enable authenticated access to the FHIR server resources.

        The Capability Statement resource allows clients to determine which
        resources are supported by a FHIR Server. Not all servers are expected to
        implement all possible queries and data elements described in the US Drug Formulary
        API. 

        # Test Methodology

        This test sequence accesses the server endpoint at `/metadata` using a
        `GET` request. It parses the Capability Statement and verifies that:

        * The endpoint is secured by an appropriate cryptographic protocol
        * The resource matches the expected FHIR version defined by the tests
        * The resource is a valid FHIR resource
        * The server claims support for JSON encoding of resources

        It collects the following information that is saved in the testing session
        for use by later tests:

        * List of resources supported
        * List of queries parameters supported
      )
      run_as_group

      PROFILES = {
        'InsurancePlan' => ['http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-PayerInsurancePlan', 'http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-Formulary'].freeze,
        'Basic' => ['http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-FormularyItem'].freeze,
        'MedicationKnowledge' => ['http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-FormularyDrug'].freeze,
        'Location' => ['http://hl7.org/fhir/us/davinci-drug-formulary/StructureDefinition/usdf-InsurancePlanLocation'].freeze
      }.freeze

      test from: :tls_version_test,
          id: :standalone_auth_tls,
          title: 'FHIR server secured by transport layer security',
          description: %(
            Systems **SHALL** use TLS version 1.2 or higher for all transmissions
            not taking place over a secure network connection.
          ),
          config: {
            options: {  minimum_allowed_version: OpenSSL::SSL::TLS1_2_VERSION }
          }
      test from: :usdf_conformance_support
      test from: :usdf_fhir_version
      test from: :usdf_json_support
      test from: :usdf_instantiate
      test from: :usdf_profile_support do
        config(
          options: { required_resources: PROFILES.keys }
        )
      end
    end
  end
end
