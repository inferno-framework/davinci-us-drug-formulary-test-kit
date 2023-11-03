require_relative 'naming'

module DaVinciUSDrugFormularyTestKit
  class Generator
    class IncludeSearchTestGenerator < SearchTestGenerator
      INCLUDE_SEARCH_PARAMS = { 'Payer Insurance Plan' => 'coverage-type', 'Formulary Item' => 'code' }.freeze

      class << self
        def generate(ig_metadata, base_output_dir)
          # The IG defines the formulary-coverage include param for both InsuancePlan profiles,
          # even though it only pertains to Payer Insurance Plan, so we explicitly exclude Formulary
          ig_metadata.groups
            .reject { |group| group.profile_name == 'Formulary' }
            .reject { |group| group.include_params.empty? }
            .each do |group|
              group.include_params.each do |include_param|
                search_meta = group.searches.find do |search|
                  search[:names].include? INCLUDE_SEARCH_PARAMS[group.profile_name]
                end
                new(group, search_meta, base_output_dir, include_param).generate
              end
            end
        end
      end

      attr_accessor :include_param

      def initialize(group_metadata, search_metadata, base_output_dir, include_param)
        super(group_metadata, search_metadata, base_output_dir)
        self.include_param = include_param
      end

      def template
        @template ||= File.read(File.join(__dir__, 'templates', 'include_search.rb.erb'))
      end

      def test_id
        "usdf_#{group_metadata.reformatted_version}_#{profile_identifier}_#{search_identifier}_include_search_test"
      end

      def search_identifier
        include_param.gsub(/[-:]/, '_').underscore
      end

      def class_name
        "#{Naming.upper_camel_case_for_profile(group_metadata)}#{search_title}IncludeSearchTest"
      end

      def search_properties
        {}.tap do |properties|
          properties[:resource_type] = "'#{resource_type}'"
          properties[:search_param_names] = search_param_names
          properties[:include_param] = "'#{include_param}'"
        end
      end

      def include_param_string
        "_include=#{include_param}"
      end

      def include_param_resource
        res_type = group_metadata.search_definitions[:"#{include_param}"][:type]
        res_type = group_metadata.search_definitions[:"#{include_param}"][:target] if res_type == 'Reference'
        res_type
      end
    end
  end
end
