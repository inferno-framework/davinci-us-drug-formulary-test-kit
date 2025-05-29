module DaVinciUSDrugFormularyTestKit
  module USDFV201
    class FormularyAuthenticatedApiSecurityTest < Inferno::Test
      title 'Protects PHI/PII in authenticated access and prevents tracking in unauthenticated access'

      description <<~DESCRIPTION
        The Health IT Module enforces proper security and privacy handling of formulary data:

        - Authenticated access to formulary services containing PHI/PII is protected using authorized, authenticated transactions in accordance with the HRex Security and Privacy framework.
        - The system does **not** retain any information through unauthenticated API access that could associate medication queries with the consumer.
      DESCRIPTION

      id :usdf_v201_authenticated_api_security

      verifies_requirements 'hl7.fhir.us.davinci-drug-formulary_2.0.1@1',
                            'hl7.fhir.us.davinci-drug-formulary_2.0.1@3'

      run do
        identifier = SecureRandom.hex(32)

        wait(
          identifier:,
          message: <<~MESSAGE
            The developer of the Health IT Module attests that:

            - Authenticated access to formulary services containing PHI/PII is protected using authorized, authenticated transactions in accordance with the HRex Security and Privacy framework.
            - The system does **not** retain any information through unauthenticated API access that could associate medication queries with the consumer.

            [Click here](#{resume_pass_url}?token=#{identifier}) if the system **meets** these requirements.

            [Click here](#{resume_fail_url}?token=#{identifier}) if the system **does not meet** these requirements.
          MESSAGE
        )
      end
    end
  end
end
