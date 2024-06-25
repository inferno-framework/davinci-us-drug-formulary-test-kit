require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciUSDrugFormularyTestKit
  module DaVinciUSDrugFormularyV201
    class BasicFormularyIncludeSearchTest < Inferno::Test
      include DaVinciUSDrugFormularyTestKit::SearchTest

      title 'Server returns InsurancePlan resources from Basic search by _include=Basic:formulary'
      description %(
        A server SHALL be capable of supporting _includes for Basic:formulary.

        This test will perform a search using _include=Basic:formulary and
        will pass if the referenced InsurancePlan is included in the response.
      )

      id :usdf_v201_basic_formulary_include_search_test

      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'Basic',
          search_param_names: ["code"],
          include_param: 'Basic:formulary',
          include_search_look_up_param: 'formulary'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.include_metadata
        @include_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'InsurancePlan', 'metadata.yml'), aliases: true))
      end

      run do
        run_include_search_test
      end
    end
  end
end
