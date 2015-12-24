module Tools
  class TorrentCreator
    TRACKER = %(http://tracker.what.cd:34000/iaqlcal9wjqzruu6oxjfn84xc38tdfam/announce)
    DATA_DIRECTORY = 'data'
    OUTPUT_DIRECTORY = 'torrents'
    PIECE_SIZE = 18

    attr_reader :files

    def initialize(files, privacy: false)
      @files = files
      @privacy = privacy
    end

    def execute
      create_output_directory

      absolute_files.each do |path|
        torrent_name = "#{File.basename(path)}.torrent"

        if File.exist?(path)
          puts "#{torrent_name} exists. Creating torrent..."

          make_torrent(torrent_name, path)
        else
          puts "#{torrent_name} doesnt exist. Skipping..."
        end
      end
    end

    def privacy?
      @privacy
    end

    private

    def create_output_directory
      Dir.mkdir(OUTPUT_DIRECTORY) unless File.exists?(OUTPUT_DIRECTORY)
    end

    def absolute_files
      files.map do |file|
        full_relative = File.join(DATA_DIRECTORY, file)

        File.absolute_path(full_relative)
      end
    end

    def make_torrent(name, path)
      output = File.join(OUTPUT_DIRECTORY, name)

      cmd = Array.new

      cmd << %(mktorrent)
      cmd << %(-l #{PIECE_SIZE})
      cmd << %(-p) if privacy?
      cmd << %(-a #{TRACKER})
      cmd << %("#{path}")
      cmd << %(-o "#{output}")

      command = cmd.join(' ')

      `#{command}`
    end
  end
end

# LIST_FILE = 'to_create'
# files = File.read(LIST_FILE).split("\n")
#
# creator = TorrentCreator.new(files, privacy: true)
# creator.execute
