require_relative '../../../read_test'

module DaVinciUSDrugFormularyTestKit
  module USDFV201
    class MedicationKnowledgeReadTest < Inferno::Test
      include DaVinciUSDrugFormularyTestKit::ReadTest

      title 'Server returns correct MedicationKnowledge resource from MedicationKnowledge read interaction'
      description 'A server SHALL support the MedicationKnowledge read interaction.'

      id :usdf_v201_medication_knowledge_read_test

      def resource_type
        'MedicationKnowledge'
      end

      def scratch_resources
        scratch[:medication_knowledge_resources] ||= {}
      end

      run do
        perform_read_test(all_scratch_resources)
      end
    end
  end
end
