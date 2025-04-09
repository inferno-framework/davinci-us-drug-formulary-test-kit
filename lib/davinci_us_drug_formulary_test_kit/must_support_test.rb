require_relative 'fhir_resource_navigation'

module DaVinciUSDrugFormularyTestKit
  module MustSupportTest
    extend Forwardable
    include FHIRResourceNavigation

    def_delegators 'self.class', :metadata

    def all_scratch_resources
      scratch_resources[:all]
    end

    def perform_must_support_test(resources)
      skip_if resources.blank?, "No #{resource_type} resources were found"

      # TODO: long term fix = allow intensional VS to be used for slicing in formulary drug
      # ticket fi-2099
      if resource_type == 'MedicationKnowledge'
        # skip slice check for drugs
        metadata.must_supports[:slices].clear
        metadata.must_supports[:elements].delete_if { |element| element[:path].include?('coding:') }
      end

      skip { assert_must_support_elements_present(resources, nil, metadata:) }
    end
  end
end
