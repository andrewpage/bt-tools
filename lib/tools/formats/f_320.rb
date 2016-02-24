module Tools
  module Formats
    class F320 < Format
      # Transcode to 320kbps CBR
      def transcode_command
        raise 'Implement transcode command.'
      end

      # Locate configuration under key 320
      def key
        '320'
      end
    end
  end
end
