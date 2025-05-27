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

      run do
        identifier = SecureRandom.hex(32)

        wait(
          identifier:,
          message: <<~MESSAGE
            The developer of the Health IT Module attests that the system includes an additional coding repetition
            for each drug with RxNorm Term Type of SCD or SBD, using the corresponding SCDG or SBDG code.

            [Click here](#{resume_pass_url}?token=#{identifier}) if the system **meets** this requirement.  
            [Click here](#{resume_fail_url}?token=#{identifier}) if the system **does not meet** this requirement.
          MESSAGE
        )
      end
    end
  end
end
