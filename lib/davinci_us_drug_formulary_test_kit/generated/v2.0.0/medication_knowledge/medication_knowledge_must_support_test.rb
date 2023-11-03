require_relative '../../../must_support_test'

module DaVinciUSDrugFormularyTestKit
  module DaVinciUSDrugFormularyV200
    class MedicationKnowledgeMustSupportTest < Inferno::Test
      include DaVinciUSDrugFormularyTestKit::MustSupportTest

      title 'All must support elements are provided in the MedicationKnowledge resources returned'
      description %(
        US Drug Formulary Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Drug Formulary Capability
        Statement. This test will look through the MedicationKnowledge resources
        found previously for the following must support elements:

        * MedicationKnowledge.code
        * MedicationKnowledge.code.coding
        * MedicationKnowledge.code.coding.code
        * MedicationKnowledge.code.coding.system
        * MedicationKnowledge.code.coding:semantic-drug
        * MedicationKnowledge.code.coding:semantic-drug-form-group
        * MedicationKnowledge.doseForm
        * MedicationKnowledge.meta.lastUpdated
        * MedicationKnowledge.status
      )

      id :usdf_v200_medication_knowledge_must_support_test

      def resource_type
        'MedicationKnowledge'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:medication_knowledge_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
