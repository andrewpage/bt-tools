module Tools
  module Execution
    # Execute a console command
    # @param [String] Command to execute.
    # @return [String] Output of the execution.
    def execute_command(command)
      `#{command}`
    end
  end
end
