module DaVinciUSDrugFormularyTestKit
  module USDFV201
    class FormularyHRexConformanceTest < Inferno::Test
      title 'Conforms to HRex conformance expectations'

      description <<~DESCRIPTION
        The Health IT Module conforms
        to the expectations described in the HRex Conformance Expectations section:

        https://hl7.org/fhir/us/davinci-hrex/STU1/conformance.html
      DESCRIPTION

      id :usdf_v201_hrex_conformance

      verifies_requirements 'hl7.fhir.us.davinci-drug-formulary_2.0.1@52'

      run do
        identifier = SecureRandom.hex(32)

        wait(
          identifier:,
          message: <<~MESSAGE
            The developer of the Health IT Module attests that the system conforms
            to the expectations described in the HRex Conformance Expectations section:

            https://hl7.org/fhir/us/davinci-hrex/STU1/conformance.html

            [Click here](#{resume_pass_url}?token=#{identifier}) if the system **meets** this requirement.  
            [Click here](#{resume_fail_url}?token=#{identifier}) if the system **does not meet** this requirement.
          MESSAGE
        )
      end
    end
  end
end