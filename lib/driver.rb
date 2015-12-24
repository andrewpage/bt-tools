require 'ostruct'
require 'optionparser'

class ToolsDriver
  DEFAULT_CONFIGURATION_PATH = File.join('config', 'configuration.json')
  AVAILABLE_COMMANDS = %i(create transcode)

  attr_reader :options

  # @param args: ARGV
  def initialize(args)
    @args = args

    # Set options defaults
    @options = OpenStruct.new(
      configuration_path: DEFAULT_CONFIGURATION_PATH
    )

    parse
  end

  # Perform actions based on command & options
  def execute
    puts options.command
  end

  private

  # Extract command + arguments from ARGV
  def parse
    # Parse all arguments first
    parser.parse!(@args)

    # Get the first argument, this is our command
    cmd = @args.pop
    raise OptionParser::MissingArgument, 'command' unless cmd

    # Set the command if it's present
    options.command = cmd.to_sym

    raise "Invalid command. Available commands: #{AVAILABLE_COMMANDS.join(', ')}." unless valid_command?
  end

  def command
    options.command
  end

  # Is this command supported?
  def valid_command?
    AVAILABLE_COMMANDS.include?(command)
  end

  # CLI option parsing singleton
  def parser
    @parse ||= OptionParser.new do |opts|
      opts.banner = "Usage: ./tools [#{AVAILABLE_COMMANDS.join('|')}] <options>"

      # Allow user to choose a different configuration file
      opts.on('-c', '--config [path]', 'Change configuration file from default.') do |path|
        options.configuration_path = path
      end

      # View program help
      opts.on_tail('-h', '--help', 'See program help.') do
        puts opts
        exit
      end
    end
  end
end
