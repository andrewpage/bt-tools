require 'json'
require 'fileutils'

module Tools
  module Actions
    class Create
      include Support::Execution
      include Support::Manifest

      attr_reader :files, :announce, :source, :output, :piece_size, :privacy

      # Create creates .torrent files for all files found in its manifest.
      # @param manifest [String] Path to JSON configuration file that lists all files to be proceesed.
      # @param announce [String] Announce URL of the primary tracker for this torrent.
      # @param source [String] Path to the directory where source files will be located.
      # @param output [String] Path to the directory where completed .torrent files will be saved.
      # @param piece_size [Fixnum] BitTorrent piece size, as a power of 2. e.g. 18 = piece size of 256kb because 2**18 is 256kb
      # @param privacy [Boolean] Should this torrent be private?
      def initialize(manifest:, announce:, source:, output:, piece_size:, privacy:)
        @announce = announce
        @source = source
        @output = output
        @piece_size = piece_size
        @privacy = privacy

        @files = extract_files(manifest)
      end

      # Create a .torrent file for every file in the manifest
      def execute
        create_output_directory

        files.each do |file_name|
          # Full relative path to the source file
          infile_path = source_path(file_name)
          # File name of output file
          outfile_name = torrent_name(file_name)
          # Full relative path to output file
          outfile_path = output_path(outfile_name)

          if can_create_torrent?(infile_path)
            make_torrent(infile_path, outfile_path)

            puts "√ #{outfile_name}"
          end
        end
      end

      private

      # Creates .torrent output directory if it does not yet exist.
      def create_output_directory
        FileUtils.mkdir_p(output) unless File.exists?(output)
      end

      # Generates a path to the source file within the source directory
      # @param file_name [String] Name of the source file, relative to the source directory.
      # @return [String] Path to the source file, relative to the calling location.
      def source_path(file_name)
        File.join(source, file_name)
      end

      # Generates a path to the output file within the output directory
      # @param file_name [String] Name of the output file, relative to the output directory.
      # @return [String] Path to the output file, relative to the calling location.
      def output_path(file_name)
        File.join(output, file_name)
      end

      # Generates the name for the finished .torrent file
      # @param file_name [String] Name of the source file
      # @return [String] .torrent name
      def torrent_name(file_name)
        basename = File.basename(file_name)

        [basename, 'torrent'].join('.')
      end

      # @param infile_path [String] Path to the source file.
      # @return [Boolean] Can we create the torrent for this source file?
      def can_create_torrent?(infile_path)
        File.exist?(infile_path)
      end

      # Create the .torrent file
      # @param name [String] Name of the completed .torrent file.
      # @param source [String] Path to the source directory for this torrent.
      # @return [String] Result of the command execution.
      def make_torrent(infile_path, outfile_path)
        cmd = Array.new
        cmd << %(mktorrent)
        cmd << %(-l #{piece_size}) # piece_size is an exponent of two
        cmd << %(-p) if privacy
        cmd << %(-a #{announce})
        cmd << %("#{infile_path}")
        cmd << %(-o "#{outfile_path}")
        cmd = cmd.join(' ')

        execute_command(cmd)
      end
    end
  end
end
