require_relative '../../../must_support_test'

module DaVinciUSDrugFormularyTestKit
  module DaVinciUSDrugFormularyV200
    class PayerInsurancePlanMustSupportTest < Inferno::Test
      include DaVinciUSDrugFormularyTestKit::MustSupportTest

      title 'All must support elements are provided in the InsurancePlan resources returned'
      description %(
        US Drug Formulary Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Drug Formulary Capability
        Statement. This test will look through the InsurancePlan resources
        found previously for the following must support elements:

        * InsurancePlan.contact.name
        * InsurancePlan.contact.name.text
        * InsurancePlan.contact.telecom
        * InsurancePlan.contact.telecom.system
        * InsurancePlan.contact.telecom.value
        * InsurancePlan.coverage
        * InsurancePlan.coverage.extension
        * InsurancePlan.coverage.type
        * InsurancePlan.coverage:drug-coverage
        * InsurancePlan.coverage:drug-coverage.benefit:drug-plan
        * InsurancePlan.coverage:drug-coverage.extension:usdf-FormularyReference-extension
        * InsurancePlan.coverageArea
        * InsurancePlan.identifier
        * InsurancePlan.meta.lastUpdated
        * InsurancePlan.name
        * InsurancePlan.period
        * InsurancePlan.plan
        * InsurancePlan.plan.specificCost
        * InsurancePlan.plan.specificCost.benefit
        * InsurancePlan.plan.specificCost.benefit.cost
        * InsurancePlan.plan.specificCost.benefit.cost.qualifiers
        * InsurancePlan.plan.specificCost.benefit.cost.value
        * InsurancePlan.plan.specificCost.benefit.cost.value.value
        * InsurancePlan.plan.specificCost.benefit.type
        * InsurancePlan.plan.specificCost.category
        * InsurancePlan.plan:drug-plan
        * InsurancePlan.plan:drug-plan.specificCost.benefit.cost:coinsurance
        * InsurancePlan.plan:drug-plan.specificCost.benefit.cost:copay
        * InsurancePlan.status
        * InsurancePlan.type
      )

      id :usdf_v200_payer_insurance_plan_must_support_test

      def resource_type
        'InsurancePlan'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:payer_insurance_plan_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
