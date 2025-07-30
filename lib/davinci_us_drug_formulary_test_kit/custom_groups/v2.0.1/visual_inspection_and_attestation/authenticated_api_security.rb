require_relative '../../../generated/v2.0.1/urls'

module DaVinciUSDrugFormularyTestKit
  module USDFV201
    class FormularyAuthenticatedApiSecurityTest < Inferno::Test
      include URLs

      title 'Protects PHI/PII in authenticated access and prevents tracking in unauthenticated access'

      description <<~DESCRIPTION
        The Health IT Module enforces proper security and privacy handling of formulary data:

        - Authenticated access to formulary services containing PHI/PII is protected using authorized, authenticated transactions in accordance with the HRex Security and Privacy framework.
        - The system does **not** retain any information through unauthenticated API access that could associate medication queries with the consumer.
      DESCRIPTION

      id :usdf_v201_authenticated_api_security

      verifies_requirements 'hl7.fhir.us.davinci-drug-formulary_2.0.1@1',
                            'hl7.fhir.us.davinci-drug-formulary_2.0.1@3'

      input :usdf_v201_authenticated_api_security_options,
            title: 'Protects PHI/PII in authenticated access and prevents tracking in unauthenticated access',
            description: %(
              The developer of the Health IT Module attests that:

                  - Authenticated access to formulary services containing PHI/PII is protected using authorized, authenticated transactions in accordance with the HRex Security and Privacy framework.
                  - The system does **not** retain any information through unauthenticated API access that could associate medication queries with the consumer.
            ),
            type: 'radio',
            default: 'false',
            options: {
              list_options: [
                {
                  label: 'Yes',
                  value: 'true'
                },
                {
                  label: 'No',
                  value: 'false'
                }
              ]
            }
      input :usdf_v201_authenticated_api_security_note,
            title: 'Notes, if applicable:',
            type: 'textarea',
            optional: true

      run do
        assert usdf_v201_authenticated_api_security_options == 'true', %(
          The following was not satisfied:

          The Health IT Module enforces proper security and privacy handling of formulary data:

          - Authenticated access to formulary services containing PHI/PII is protected using authorized, authenticated transactions in accordance with the HRex Security and Privacy framework.
          - The system does **not** retain any information through unauthenticated API access that could associate medication queries with the consumer.

        )
        pass usdf_v201_authenticated_api_security_note if usdf_v201_authenticated_api_security_note.present?
      end

    end
  end
end
