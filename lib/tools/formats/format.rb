module Tools
  module Formats
    class Format
      include Support::Manifest

      attr_reader :files

      def transcode_command
        require_subclass
      end

      def key
        require_subclass
      end

      private

      # Initialize a Format with a manifest file
      # @param manifest [String] Path to manifest file.
      def initialize(manifest:)
        @files = extract_files(manifest)
      end

      def require_subclass
        fail 'Must be implemented by subclass.'
      end
    end
  end
end
