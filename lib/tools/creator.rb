require 'json'

module Tools
  class Creator
    BASE_CONFIGURATION_DIRECTORY = 'config'

    attr_reader :files, :announce, :source, :output, :piece_size, :privacy

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
    def extract_files(manifest)
      contents = File.read(manifest)
      json = JSON.parse(contents)

      json['files']
    end

    def create_output_directory
      Dir.mkdir(output) unless File.exists?(output)
    end

    # Create the .torrent file
    def mktorrent(name, path)
      outfile = File.join(output, name)

      cmd = Array.new
      cmd << %(mktorrent)
      cmd << %(-l #{piece_size})
      cmd << %(-p) if privacy
      cmd << %(-a #{announce})
      cmd << %("#{path}")
      cmd << %(-o "#{outfile}")
      cmd = cmd.join(' ')

      `#{command}`
    end
  end
end
