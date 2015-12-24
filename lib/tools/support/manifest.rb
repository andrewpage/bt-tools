module Tools
  module Support
    module Manifest
      private

      # Extract list of files to process from manifest JSON
      # @param manifest [String] Path to JSON configuration file that lists all files to be proceesed.
      # @return [Array] File paths that were contained within the manifest file.
      def extract_files(manifest)
        contents = File.read(manifest)
        json = JSON.parse(contents)

        json['files']
      end
    end
  end
end
