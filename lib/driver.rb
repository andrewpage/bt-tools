require 'torrent_creator'
require 'transcoder'

module Tools
  class Driver
    CREATE_REQUIRED_KEYS = %i(announceURL source output pieceSize)
    TRANSCODE_REQUIRED_KEYS = %i(formats source output)

    # Create all torrent files
    def self.create(config)
    end

    # Transcode all FLAC files
    def self.transcode(config)
    end
  end
end
