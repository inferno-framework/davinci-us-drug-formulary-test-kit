require_relative 'visual_inspection_and_attestation/authenticated_api_security'
require_relative 'visual_inspection_and_attestation/member_scoped_access'
require_relative 'visual_inspection_and_attestation/drug_display_name'
require_relative 'visual_inspection_and_attestation/hrex_conformance'
require_relative 'visual_inspection_and_attestation/rxnorm_coding'

module DaVinciUSDrugFormularyTestKit
  module USDFV201
    class PDexUSDFVisualInspectionAndAttestationGroup < Inferno::TestGroup
      id :usdf_v201_visual_inspection_and_attestation
      title 'Visual Inspection and Attestation'

      description <<~DESCRIPTION
        Perform visual inspections or attestations to ensure that the Health IT Module is conformant
        to the Da Vinci Payer Data Exchange US Drug Formulary IG requirements.
      DESCRIPTION

      run_as_group

      test from: :usdf_v201_authenticated_api_security
      test from: :usdf_v201_member_scoped_access
      test from: :usdf_v201_drug_display_name
      test from: :usdf_v201_hrex_conformance
      test from: :usdf_v201_rxnorm_coding
    end
  end
end
