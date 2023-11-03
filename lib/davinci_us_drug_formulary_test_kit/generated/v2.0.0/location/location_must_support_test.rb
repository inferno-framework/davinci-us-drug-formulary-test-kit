require_relative '../../../must_support_test'

module DaVinciUSDrugFormularyTestKit
  module DaVinciUSDrugFormularyV200
    class LocationMustSupportTest < Inferno::Test
      include DaVinciUSDrugFormularyTestKit::MustSupportTest

      title 'All must support elements are provided in the Location resources returned'
      description %(
        US Drug Formulary Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Drug Formulary Capability
        Statement. This test will look through the Location resources
        found previously for the following must support elements:

        * Location.address or Location.extension:region
      )

      id :usdf_v200_location_must_support_test

      def resource_type
        'Location'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:location_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
