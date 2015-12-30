require 'active_support/core_ext/string'

module Tools
  module Formats
    class Format
      include Support::Manifest

      attr_reader :files

      # Generate Format objects for all objects in the `formats` hash
      # @param formats [Hash] K: format name, V: path to manifest file
      # @return [Array<Format>] Returns an array of Format objects
      def self.create_from_configuration(formats)
        initialized_formats = []

        formats.each do |format_str, manifest_path|
          # Format prefixed with an F
          format_name = format_class_name(format_str)

          # Constantized name, namespaced to the current namespace
          format_class = namespaced_class(format_name)

          # Initialize a new Format object with the corresponding manifest
          format_object = format_class.new(manifest_path)

          # Add it to the array to be returned
          initialized_formats << format_object
        end

        initialized_formats
      end

      def transcode_command
        require_subclass
      end

      def key
        require_subclass
      end

      private

      # Generate the proper convention for a Format class name
      # @param format_name [String] Name of the format.
      # @return [String] format_name prefixed with "F"
      def self.format_class_name(format_name)
        "F#{format_name}"
      end

      # Generate a constantized class name under the same namespace
      # @param klass [String] Name of class to constantize.
      # @return [Class] Constantized new class name.
      def self.namespaced_class(klass)
        class_string = self.to_s
        namespace = class_string.deconstantize

        [namespace, klass].join('::').constantize
      end

      # Initialize a Format with a manifest file
      # @param manifest [String] Path to manifest file.
      def initialize(manifest_path)
        @files = extract_files(manifest_path)
      end

      def require_subclass
        fail 'Must be implemented by subclass.'
      end
    end
  end
end
