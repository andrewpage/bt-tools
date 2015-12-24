require 'json'

module Tools
  class Creator
    attr_reader :files, :announce, :source, :output, :piece_size, :privacy

    # Tools::Creator creates .torrent files for all files found in its manifest.
    #
    # @param manifest Path to JSON configuration file that lists all files to be proceesed.
    # @param announce Announce URL of the primary tracker for this torrent.
    # @param source Path to the directory where source files will be located.
    # @param output Path to the directory where completed .torrent files will be saved.
    # @param piece_size BitTorrent piece size, as a power of 2. e.g. 18 = piece size of 256kb because 2**18 is 256kb
    # @param privacy Should this torrent be private?
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

      files.each do |path|
        torrent_name = "#{File.basename(path)}.torrent"

        if File.exist?(path)
          make_torrent(torrent_name, path)
          puts "√ #{torrent_name}"
        end
      end
    end

    private

    # Extract list of files to process from manifest JSON
    # @param manifest Path to JSON configuration file that lists all files to be proceesed.
    def extract_files(manifest)
      contents = File.read(manifest)
      json = JSON.parse(contents)

      json['files']
    end

    # Creates .torrent output directory if it does not yet exist.
    def create_output_directory
      Dir.mkdir_p(output) unless File.exists?(output)
    end

    # Create the .torrent file
    # @param name Name of the completed .torrent file.
    # @param source Path to the source directory for this torrent.
    def mktorrent(name, source)
      outfile = File.join(output, name)

      cmd = Array.new
      cmd << %(mktorrent)
      cmd << %(-l #{piece_size})
      cmd << %(-p) if privacy
      cmd << %(-a #{announce})
      cmd << %("#{source}")
      cmd << %(-o "#{outfile}")
      cmd = cmd.join(' ')

      `#{command}`
    end
  end
end
