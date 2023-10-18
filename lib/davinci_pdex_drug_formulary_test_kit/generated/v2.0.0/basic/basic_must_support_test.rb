require_relative '../../../must_support_test'

module DaVinciPDEXDrugFormularyTestKit
  module USCoreV200
    class BasicMustSupportTest < Inferno::Test
      include DaVinciPDEXDrugFormularyTestKit::MustSupportTest

      title 'All must support elements are provided in the Basic resources returned'
      description %(
        US Drug Formulary Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Drug Formulary Capability
        Statement. This test will look through the Basic resources
        found previously for the following must support elements:

        * Basic.extension:usdf-AvailabilityPeriod-extension
        * Basic.extension:usdf-AvailabilityStatus-extension
        * Basic.extension:usdf-DrugTierID-extension
        * Basic.extension:usdf-FormularyReference-extension
        * Basic.extension:usdf-PharmacyBenefitType-extension
        * Basic.extension:usdf-PriorAuthorization-extension
        * Basic.extension:usdf-QuantityLimit-extension
        * Basic.extension:usdf-StepTherapyLimit-extension
        * Basic.meta.lastUpdated
        * Basic.subject
      )

      id :us_core_v200_basic_must_support_test

      def resource_type
        'Basic'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:basic_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
