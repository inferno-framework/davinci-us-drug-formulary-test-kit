require 'active_support/all'
require 'fhir_models'
require 'pathname'
require 'rubygems/package'
require 'zlib'
require_relative 'ig_resources'
require 'pry'

module DaVinciUSDrugFormularyTestKit
  class Generator
    class IGLoader
      attr_accessor :ig_file_name

      def initialize(ig_file_name)
        self.ig_file_name = ig_file_name
      end

      def ig_resources
        @ig_resources ||= IGResources.new
      end

      def load
        # `IGResources`` uses the first resource it finds for a resource type.
        # Perform `load_standalone_resources` first so that any modified resources
        # are accessed instead of the original.
        load_standalone_resources_after
        load_ig
        load_standalone_resources
      end

      def load_ig

        tar = Gem::Package::TarReader.new(
          Zlib::GzipReader.open(ig_file_name)
        )

        tar.each do |entry|
          next if entry.directory?

          file_name = entry.full_name.split('/').last

          next unless file_name.end_with? '.json'

          next unless entry.full_name.start_with? 'package/'

          begin
            resource = FHIR.from_contents(entry.read)
            next if resource.nil?
          rescue StandardError
            puts "#{file_name} does not appear to be a FHIR resource."
            next
          end

          ig_resources.add(resource)
        end

        ig_resources
      end

      def load_standalone_resources
        ig_directory = ig_file_name.chomp('.tgz')

        Dir.glob(File.join(ig_directory, '*.json')).each do |file_path|
          resource = FHIR.from_contents(File.read(file_path))
          next if resource.nil?

          if resource.resourceType == 'Bundle' && !resource.entry.nil?
            resource_arr = resource.entry
            resource_arr.each do |entry|
              ig_resources.add(entry.resource)
            end
          else
            ig_resources.add(resource)
          end
        rescue StandardError
          file_name = file_path.split('/').last
          puts "#{file_name} does not appear to be a FHIR resource."
          next
        end

        ig_resources
      end

      def load_standalone_resources_after
        ig_directory = "#{ig_file_name.chomp('.tgz')}_after"

        Dir.glob(File.join(ig_directory, '*.json')).each do |file_path|
          resource = FHIR.from_contents(File.read(file_path))
          next if resource.nil?

          if resource.resourceType == 'Bundle' && !resource.entry.nil?
            resource_arr = resource.entry
            resource_arr.each do |entry|
              ig_resources.add(entry.resource)
            end
          else
            ig_resources.add(resource)
          end
        rescue StandardError
          file_name = file_path.split('/').last
          puts "#{file_name} does not appear to be a FHIR resource."
          next
        end

        ig_resources
      end
    end
  end
end
