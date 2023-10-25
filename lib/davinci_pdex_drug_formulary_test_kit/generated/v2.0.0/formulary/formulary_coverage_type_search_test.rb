require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXDrugFormularyTestKit
  module DaVinciPDEXDrugFormularyV200
    class FormularyCoverageTypeSearchTest < Inferno::Test
      include DaVinciPDEXDrugFormularyTestKit::SearchTest

      title 'Server returns valid results for InsurancePlan search by coverage-type'
      description %(
A server SHALL support searching by
coverage-type on the InsurancePlan resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Drug Formulary](http://hl7.org/fhir/us/davinci-drug-formulary//CapabilityStatement-usdf-server.html)

      )

      id :us_core_v200_formulary_coverage_type_search_test
      optional
  
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'InsurancePlan',
          search_param_names: ['coverage-type'],
          token_search_params: ['coverage-type']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:formulary_resources] ||= {}
      end

      run do
        run_search_test 
      end
    end
  end
end
