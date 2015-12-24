require 'ostruct'
require 'optionparser'

class ToolsDriver
  DEFAULT_CONFIGURATION_PATH = File.join('config', 'configuration.json')

  attr_reader :options

  def initialize(args)
    @args = args
    @options = OpenStruct.new(
      configuration_path: DEFAULT_CONFIGURATION_PATH
    )

    parse
  end

  def execute
    puts options.command
  end

  private

  def parse
    parser.parse!(@args)

    # Get the first argument, this is our command
    command = @args.pop
    raise OptionParser::MissingArgument, 'command' unless command

    # Set the command if it's present
    options.command = command.to_sym
  end

  def parser
    @parse ||= OptionParser.new do |opts|
      opts.banner = 'Usage: ./tools [command] <options>'

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
