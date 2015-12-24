require_relative 'creator'
require_relative 'transcoder'

require 'json'

module Tools
  CREATE_REQUIRED_KEYS = %i(announceURL source output pieceSize)
  TRANSCODE_REQUIRED_KEYS = %i(formats source output)

  # Create all torrent files
  def self.create(config_path)
    # TODO: Ensure that the manifest path is relative to the working directory. File.expand_path?
    config = read_config(config_path, :create)

    # Initialize .torrent Creator
    creator = Creator.new(
      manifest: config['manifest'],
      announce: config['announceURL'],
      source: config['source'],
      output: config['output'],
      piece_size: config['pieceSize'],
      privacy: config['private']
    )

    # Create torrents
    creator.execute
  end

  # Transcode all FLAC files
  def self.transcode(config_path)
    config = read_config(config_path, :transcode)
  end

  private

  # Read configuration and parse JSON
  def self.read_config(path, action = nil)
    contents = File.read(path)
    json = JSON.parse(contents)

    action ? json[action.to_s] : json
  end
end
