require_relative 'creator'
require_relative 'transcoder'

require 'json'

module Tools
  CREATE_REQUIRED_KEYS = %i(announceURL source output pieceSize)
  TRANSCODE_REQUIRED_KEYS = %i(formats source output)

  # Create .torrent files for each entry in the config manifest
  #
  # @param config_path Path to the primary configuration file.
  def self.create(config_path)
    # TODO: Ensure that the manifest path is relative to the configuration file. File.expand_path?
    config = read_config(config_path, :create)

    # Get path for the manifest file
    manifest = config_path(config['manifest'])

    # Initialize .torrent Creator
    creator = Creator.new(
      manifest: manifest,
      announce: config['announceURL'],
      source: config['source'],
      output: config['output'],
      piece_size: config['pieceSize'],
      privacy: config['private']
    )

    # Create torrents
    creator.execute
  end

  # Transcode all FLAC files to the desired formats
  #
  # @param config_path Path to the primary configuration file.
  def self.transcode(config_path)
    config = read_config(config_path, :transcode)
  end

  private

  # Read configuration and parse JSON
  #
  # @param path Path of the configuration file to parse.
  # @param action Select inner hash corresponding to this key.
  def self.read_config(path, action = nil)
    contents = File.read(path)
    json = JSON.parse(contents)

    action ? json[action.to_s] : json
  end

  # Generate a path for the secondary config file that is relative
  # to the primary config file
  #
  # @param main The primary configuration file
  # @param config The secondary configuration file
  def self.config_path(main, config)
    config_directory = File.dirname(main)

    File.join(config_directory, config)
  end
end
