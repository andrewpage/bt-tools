module Tools
  class InvalidCommandException < StandardError
    # InvalidCommandException indicates to the user that the specified command is not supported.
    # @param command [Symbol] The command that the user passed to this program.
    # @param available_commands [Array] The commands that they are able to pass to this program.
    def initialize(command, available_commands)
      @command = command
      @available_commands = available_commands
    end

    def message
      %(Invalid command "#{@command}". Available commands: #{available_commands_string}.)
    end

    private

    # Concatenates the available commands together into a pretty string
    # @return [String] All available commands separated by commas.
    def available_commands_string
      @available_commands.join(', ')
    end
  end

  class MissingConfigurationException < StandardError
    # MissingConfigurationException indicates to the user that they are missing their configuration file.
  end

  class MissingKeysException < StandardError
    # MissingKeysException indicates to the user that their configuration JSON is missing critical required keys.
    # @param required_keys [Array] Keys that they are missing.
    def initialize(required_keys)
      @required_keys = required_keys
    end

    def message
      %(Your configuration file is missing the following required keys: #{required_keys_string})
    end

    private

    # Concatenates the required keys together into a pretty string
    # @return [String] All required keys separated by commas.
    def required_keys_string
      @required_keys.map { |key| %('#{key}') }.join(', ')
    end
  end
end
