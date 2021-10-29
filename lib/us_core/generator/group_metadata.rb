module USCore
  class Generator
    class GroupMetadata
      ATTRIBUTES = [
        :name,
        :class_name,
        :version,
        :reformatted_version,
        :resource,
        :profile_url,
        :profile_name,
        :title,
        :interactions,
        :operations,
        :searches,
        :search_definitions,
        :include_params,
        :revincludes,
        :required_concepts,
        :must_supports,
        :mandatory_elements,
        :bindings,
        :references,
        :tests,
        :id,
        :file_name
      ].freeze

      ATTRIBUTES.each { |name| attr_accessor name }

      def initialize(**params)
        params.each do |key, value|
          raise "Unknown attribute #{key}" unless ATTRIBUTES.include? key

          instance_variable_set(:"@#{key}", value)
        end
      end

      def add_test(id:, file_name:)
        self.tests ||= []
        self.tests << {
          id: id,
          file_name: file_name
        }
      end

      def to_hash
        ATTRIBUTES.each_with_object({}) { |key, hash| hash[key] = send(key) }
      end
    end
  end
end
