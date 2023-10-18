require_relative '../../../must_support_test'

module DaVinciPDEXDrugFormularyTestKit
  module USCoreV200
    class FormularyMustSupportTest < Inferno::Test
      include DaVinciPDEXDrugFormularyTestKit::MustSupportTest

      title 'All must support elements are provided in the InsurancePlan resources returned'
      description %(
        US Drug Formulary Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Drug Formulary Capability
        Statement. This test will look through the InsurancePlan resources
        found previously for the following must support elements:

        * InsurancePlan.identifier
        * InsurancePlan.meta.lastUpdated
        * InsurancePlan.name
        * InsurancePlan.period
        * InsurancePlan.status
        * InsurancePlan.type.coding.code
      )

      id :us_core_v200_formulary_must_support_test

      def resource_type
        'InsurancePlan'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:formulary_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
