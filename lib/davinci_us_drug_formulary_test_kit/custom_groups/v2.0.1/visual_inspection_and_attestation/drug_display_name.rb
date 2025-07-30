require_relative '../../../generated/v2.0.1/urls'

module DaVinciUSDrugFormularyTestKit
  module USDFV201
    class FormularyDrugNameSearchDisplayTest < Inferno::Test
      include URLs

      title 'Supports drug name search using general drug form group codes and names'

      description <<~DESCRIPTION
        The Health IT Module supports searching for drugs using general drug form group codes (SCDG or SBDG)
        and ensures that the display name associated with those codes is included in search results.
      DESCRIPTION

      id :usdf_v201_drug_display_name

      verifies_requirements 'hl7.fhir.us.davinci-drug-formulary_2.0.1@19'

      input :usdf_v201_drug_display_name_options,
            title: 'Supports drug name search using general drug form group codes and names',
            description: %(
              I attest that the Health IT Module supports searching for drugs using general drug form
                  group codes (SCDG or SBDG) and ensures that the display name associated with those codes is included in search results.
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
      input :usdf_v201_drug_display_name_note,
            title: 'Notes, if applicable:',
            type: 'textarea',
            optional: true

      run do
        assert usdf_v201_drug_display_name_options == 'true', %(
          The following was not satisfied:

          The Health IT Module supports searching for drugs using general drug form group codes (SCDG or SBDG)
          and ensures that the display name associated with those codes is included in search results.

        )
        pass usdf_v201_drug_display_name_note if usdf_v201_drug_display_name_note.present?
      end

    end
  end
end
