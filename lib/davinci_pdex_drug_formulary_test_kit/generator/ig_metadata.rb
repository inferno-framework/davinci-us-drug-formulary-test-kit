module DaVinciPDEXDrugFormularyTestKit
  class Generator
    class IGMetadata
      attr_accessor :ig_version, :groups

      def reformatted_version
        @reformatted_version ||= ig_version.delete('.').gsub('-', '_')
      end

      def ordered_groups
        @ordered_groups ||= groups
      end

      def delayed_profiles
        @delayed_profiles ||=
          delayed_groups.map(&:profile_url)
      end

      def postprocess_groups(ig_resources)
        groups.each do |group|
          group.add_delayed_references(delayed_profiles, ig_resources)
        end
      end

      def to_hash
        {
          ig_version: ig_version,
          groups: groups.map(&:to_hash)
        }
      end
    end
  end
end
