require_relative 'naming'

module DaVinciUSDrugFormularyTestKit
  class Generator
    class GroupGenerator
      class << self
        def generate(ig_metadata, base_output_dir)
          ig_metadata.ordered_groups
            .each { |group| new(group, base_output_dir).generate }
        end
      end

      attr_accessor :group_metadata, :base_output_dir

      def initialize(group_metadata, base_output_dir)
        self.group_metadata = group_metadata
        self.base_output_dir = base_output_dir
      end

      def template
        @template ||= File.read(File.join(__dir__, 'templates', 'group.rb.erb'))
      end

      def output
        @output ||= ERB.new(template).result(binding)
      end

      def base_output_file_name
        "#{class_name.underscore}.rb"
      end

      def base_metadata_file_name
        'metadata.yml'
      end

      def class_name
        "#{Naming.upper_camel_case_for_profile(group_metadata)}Group"
      end

      def module_name
        "USDF#{group_metadata.reformatted_version.upcase}"
      end

      def title
        group_metadata.title
      end

      def short_description
        group_metadata.short_description
      end

      def output_file_name
        File.join(base_output_dir, base_output_file_name)
      end

      def metadata_file_name
        File.join(base_output_dir, profile_identifier, base_metadata_file_name)
      end

      def profile_identifier
        Naming.snake_case_for_profile(group_metadata)
      end

      def group_id
        "usdf_#{group_metadata.reformatted_version}_#{profile_identifier}"
      end

      def resource_type
        group_metadata.resource
      end

      def search_validation_resource_type
        "#{resource_type} resources"
      end

      def profile_name
        group_metadata.profile_name
      end

      def profile_url
        group_metadata.profile_url
      end

      def optional?
        false
      end

      def generate
        File.write(output_file_name, output)
        group_metadata.id = group_id
        group_metadata.file_name = base_output_file_name
        File.write(metadata_file_name, YAML.dump(group_metadata.to_hash))
      end

      def test_id_list
        @test_id_list ||=
          group_metadata.tests.map { |test| test[:id] }
      end

      def test_file_list
        @test_file_list ||=
          group_metadata.tests.map do |test|
            name_without_suffix = test[:file_name].delete_suffix('.rb')
            name_without_suffix.start_with?('..') ? name_without_suffix : "#{profile_identifier}/#{name_without_suffix}"
          end
      end

      def required_searches
        group_metadata.searches.select { |search| search[:expectation] == 'SHALL' }
      end

      def search_param_name_string
        required_searches
          .map { |search| search[:names].join(' + ') }
          .map { |names| "* #{names}" }
          .join("\n")
      end

      def search_description
        return '' if required_searches.blank?

        <<~SEARCH_DESCRIPTION
          ## Searching
          This test sequence will first perform each required search associated
          with this resource. This sequence will perform searches with the
          following parameters:

          #{search_param_name_string}

          ### Search Parameters
          The first search uses the selected resources from the prior launch
          sequence. Any subsequent searches will look for its parameter values
          from the results of the first search. If a value cannot be found this way, the search is skipped.

          ### Search Validation
          Inferno will retrieve up to the first 20 bundle pages of the reply for
          #{search_validation_resource_type} and save them for subsequent tests. Each of
          these resources is then checked to see if it matches the searched
          parameters in accordance with [FHIR search
          guidelines](https://www.hl7.org/fhir/search.html).
        SEARCH_DESCRIPTION
      end

      def description
        <<~DESCRIPTION
          # Background

          The USDF #{title} sequence verifies that the system under test is
          able to provide correct responses for #{resource_type} queries. These queries
          must contain resources conforming to the #{profile_name} as
          specified in the USDF #{group_metadata.version} Implementation Guide.

          # Testing Methodology
          #{search_description}

          ## Must Support
          Each profile contains elements marked as "must support". This test
          sequence expects to see each of these elements at least once. If at
          least one cannot be found, the test will fail. The test will look
          through the #{resource_type} resources found in the first test for these
          elements.

          ## Profile Validation
          Each resource returned from the first search is expected to conform to
          the [#{profile_name}](#{profile_url}). Each element is checked against
          teminology binding and cardinality requirements.

          Elements with a required binding are validated against their bound
          ValueSet. If the code/system in the element is not part of the ValueSet,
          then the test will fail.

          ## Reference Validation
          At least one instance of each external reference in elements marked as
          "must support" within the resources provided by the system must resolve.
          The test will attempt to read each reference found and will fail if no
          read succeeds.
        DESCRIPTION
      end
    end
  end
end
