require_relative '../../../generated/v2.0.1/urls'

module DaVinciUSDrugFormularyTestKit
  module USDFV201
    class FormularyHRexConformanceTest < Inferno::Test
      include URLs

      title 'Conforms to HRex conformance expectations'

      description <<~DESCRIPTION
        The Health IT Module conforms
        to the expectations described in the HRex Conformance Expectations section:

        https://hl7.org/fhir/us/davinci-hrex/STU1/conformance.html
      DESCRIPTION

      id :usdf_v201_hrex_conformance

      verifies_requirements 'hl7.fhir.us.davinci-drug-formulary_2.0.1@52'

      input :usdf_v201_hrex_conformance_options,
            title: 'Conforms to HRex conformance expectations',
            description: %(
              The developer of the Health IT Module attests that the system conforms
                  to the expectations described in the HRex Conformance Expectations section:

                  https://hl7.org/fhir/us/davinci-hrex/STU1/conformance.html
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
      input :usdf_v201_hrex_conformance_note,
            title: 'Notes, if applicable:',
            type: 'textarea',
            optional: true

      run do
        assert usdf_v201_hrex_conformance_options == 'true', %(
          The following was not satisfied:

          The Health IT Module conforms
          to the expectations described in the HRex Conformance Expectations section:

          https://hl7.org/fhir/us/davinci-hrex/STU1/conformance.html

        )
        pass usdf_v201_hrex_conformance_note if usdf_v201_hrex_conformance_note.present?
      end

    end
  end
end
