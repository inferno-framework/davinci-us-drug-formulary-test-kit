module DaVinciUSDrugFormularyTestKit
  module USDFV201
    class FormularyAuthenticatedAccessTest < Inferno::Test
      title 'Provides member-associated formulary data via authenticated access'

      description <<~DESCRIPTION
        The Health IT Module makes profiled
        resources (FormularyItem, FormularyDrug) associated with a member’s plan
        available via authenticated access.
      DESCRIPTION

      id :usdf_v201_authenticated_access

      verifies_requirements 'hl7.fhir.us.davinci-drug-formulary_2.0.1@11'

      run do
        identifier = SecureRandom.hex(32)

        wait(
          identifier:,
          message: <<~MESSAGE
            I attest that Health IT Module makes profiled
            resources (FormularyItem, FormularyDrug) associated with a member’s plan
            available via authenticated access.

            [Click here](#{resume_pass_url}?token=#{identifier}) if the system **meets** this requirement.  
            [Click here](#{resume_fail_url}?token=#{identifier}) if the system **does not meet** this requirement.
          MESSAGE
        )
      end
    end
  end
end