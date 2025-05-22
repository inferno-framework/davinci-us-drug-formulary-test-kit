module DaVinciUSDrugFormularyTestKit
  module USDFV201
    class FormularyDrugNameSearchDisplayTest < Inferno::Test
      title 'Supports drug name search using general drug form group codes and names'

      description <<~DESCRIPTION
        The Health IT Module supports searching for drugs using general drug form group codes (SCDG or SBDG)
        and ensures that the display name associated with those codes is included in search results.
      DESCRIPTION

      id :usdf_v201_drug_display_name

      verifies_requirements 'hl7.fhir.us.davinci-drug-formulary_2.0.1@19'

      run do
        identifier = SecureRandom.hex(32)

        wait(
          identifier:,
          message: <<~MESSAGE
            I attest that the Health IT Module supports searching for drugs using general drug form
            group codes (SCDG or SBDG) and ensures that the display name associated with those codes is included in search results.

            [Click here](#{resume_pass_url}?token=#{identifier}) if the system **meets** this requirement.

            [Click here](#{resume_fail_url}?token=#{identifier}) if the system **does not meet** this requirement.
          MESSAGE
        )

      end
    end
  end
end