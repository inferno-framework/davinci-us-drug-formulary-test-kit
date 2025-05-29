require_relative '../../../generated/v2.0.1/urls'

module DaVinciUSDrugFormularyTestKit
  module USDFV201
    class FormularyMemberScopedAccessTest < Inferno::Test
      include URLs

      title 'Returns plan-appropriate formulary data through authenticated access'

      description <<~DESCRIPTION
        When queried through authenticated access, the Health IT Module returns:
          - All Formularies associated with the member’s group(s), if applicable,
          - Only generally available (non-group-restricted) Formularies if the member is not in a group.

        The Health IT Module also provides access to profiled resources (FormularyItem, FormularyDrug) tied to the member’s available plans.
      DESCRIPTION

      id :usdf_v201_member_scoped_access

      verifies_requirements 'hl7.fhir.us.davinci-drug-formulary_2.0.1@4',
                            'hl7.fhir.us.davinci-drug-formulary_2.0.1@5',
                            'hl7.fhir.us.davinci-drug-formulary_2.0.1@11'

      run do
        identifier = SecureRandom.hex(32)

        wait(
          identifier:,
          message: <<~MESSAGE
            The developer of the Health IT Module attests that:

            - When queried through authenticated access, the Health IT Module returns:
              - All Formularies associated with the member’s group(s), if applicable,
              - Only generally available (non-group-restricted) Formularies if the member is not in a group.
            - The Health IT Module also provides access to profiled resources (FormularyItem, FormularyDrug) tied to the member’s available plans.

            [Click here](#{resume_pass_url}?token=#{identifier}) if the system **meets** these requirements.

            [Click here](#{resume_fail_url}?token=#{identifier}) if the system **does not meet** these requirements.
          MESSAGE
        )
      end
    end
  end
end