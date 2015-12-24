require_relative 'creator'
require_relative 'transcoder'

require_relative 'exceptions'

require 'json'

module Tools
  CREATE_REQUIRED_KEYS = %i(announceURL source output pieceSize)
  TRANSCODE_REQUIRED_KEYS = %i(formats source output)

  # Create .torrent files for each entry in the config manifest
  # @param config_path [String] Path to the primary configuration file.
  def self.create(config_path)
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
  # @param config_path [String] Path to the primary configuration file.
  def self.transcode(config_path)
    config = read_config(config_path, :transcode)
  end

  private

  # Validates that all required keys are present in the configuration
  # @param config [Hash] Configuration hash to validate.
  # @param required_keys [Array] Keys that must be present in the configuration.
  def self.validate_configuration(config, required_keys)
    required_keys.each do |key|

    end
  end

  # Read configuration and parse JSON
  #
  # @param path [String] Path of the configuration file to parse.
  # @param action [String] Select inner hash corresponding to this key.
  def self.read_config(path, action = nil)
    contents = File.read(path)
    json = JSON.parse(contents)

    action ? json[action.to_s] : json
  end

  # Generate a path for the secondary config file that is relative
  # to the primary config file
  #
  # @param main [String] Path to the primary configuration file.
  # @param config [String] Path to the secondary configuration file.
  def self.config_path(main, config)
    config_directory = File.dirname(main)

    File.join(config_directory, config)
  end
end
