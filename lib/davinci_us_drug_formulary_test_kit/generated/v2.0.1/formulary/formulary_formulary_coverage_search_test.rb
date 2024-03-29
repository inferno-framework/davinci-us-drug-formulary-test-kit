require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciUSDrugFormularyTestKit
  module DaVinciUSDrugFormularyV201
    class FormularyFormularyCoverageSearchTest < Inferno::Test
      include DaVinciUSDrugFormularyTestKit::SearchTest

      title 'Server returns valid results for InsurancePlan search by formulary-coverage'
      description %(
A server SHALL support searching by
formulary-coverage on the InsurancePlan resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Drug Formulary](http://hl7.org/fhir/us/davinci-drug-formulary/STU2/CapabilityStatement-usdf-server.html)

      )

      id :usdf_v201_formulary_formulary_coverage_search_test
      optional
  
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'InsurancePlan',
          search_param_names: ['formulary-coverage'],
          test_reference_variants: true
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
