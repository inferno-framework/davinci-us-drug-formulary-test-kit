require_relative '../../../generated/v2.0.1/urls'

module DaVinciUSDrugFormularyTestKit
  module USDFV201
    class FormularyRxNormCodingTest < Inferno::Test
      include URLs

      title 'Includes RxNorm SCDG/SBDG codes for SCD/SBD drug types'

      description <<~DESCRIPTION
        The Health IT Module includes an additional coding repetition for each drug with
        RxNorm Term Type of SCD or SBD, using the corresponding SCDG or SBDG code.
      DESCRIPTION

      id :usdf_v201_rxnorm_coding

      verifies_requirements 'hl7.fhir.us.davinci-drug-formulary_2.0.1@14'

      input :usdf_v201_rxnorm_coding_options,
            title: 'Includes RxNorm SCDG/SBDG codes for SCD/SBD drug types',
            description: %(
              The developer of the Health IT Module attests that the system includes an additional coding repetition
                  for each drug with RxNorm Term Type of SCD or SBD, using the corresponding SCDG or SBDG code.
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
      input :usdf_v201_rxnorm_coding_note,
            title: 'Notes, if applicable:',
            type: 'textarea',
            optional: true

      run do
        assert usdf_v201_rxnorm_coding_options == 'true', %(
          The following was not satisfied:

          The Health IT Module includes an additional coding repetition for each drug with
          RxNorm Term Type of SCD or SBD, using the corresponding SCDG or SBDG code.

        )
        pass usdf_v201_rxnorm_coding_note if usdf_v201_rxnorm_coding_note.present?
      end

    end
  end
end
