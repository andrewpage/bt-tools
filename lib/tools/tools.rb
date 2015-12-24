require_relative 'torrent_creator'
require_relative 'transcoder'

module Tools
  CREATE_REQUIRED_KEYS = %i(announceURL source output pieceSize)
  TRANSCODE_REQUIRED_KEYS = %i(formats source output)

  # Create all torrent files
  def self.create(config_path)
    puts "Create: #{config_path}"
  end

  # Transcode all FLAC files
  def self.transcode(config_path)
    puts "Transcode: #{config_path}"
  end
end
