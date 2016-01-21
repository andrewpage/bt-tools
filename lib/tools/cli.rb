require 'ostruct'
require 'optionparser'

module Tools
  class CLI
    AVAILABLE_COMMANDS = %i(create transcode)

    attr_reader :options

    # CLI will parse all command line options
    # @param args [Array] Arguments, typically from ARGV.
    def initialize(args)
      @args = args
      @options = OpenStruct.new

      parse
      validate
    end

    # Perform actions based on command & options
    def execute
      Tools.public_send(command, options.configuration_path)
    end

    private

    # Extract command + arguments from ARGV
    def parse
      # Parse all arguments first
      option_parser.parse!(arguments)

      # Get the first argument, this is our command
      cmd = arguments.pop
      raise OptionParser::MissingArgument, 'command' unless cmd

      # Set the command if it's present
      options.command = cmd.to_sym
    end

    # @return [Array] Command line arguments passed into this program.
    def arguments
      @args
    end

    # @return [Symbol] Command that was specified to this program
    def command
      options.command
    end

    # Ensure we have valid data
    def validate
      raise Tools::InvalidCommandException.new(command, AVAILABLE_COMMANDS) unless valid_command?
    end

    # @return [Boolean] Is this command supported?
    def valid_command?
      AVAILABLE_COMMANDS.include?(command)
    end

    # CLI option parsing singleton
    # @return [OptionParser] Object that can parse command line objects according to our specifications.
    def option_parser
      @parser ||= OptionParser.new do |opts|
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
end
