module Tools
  module Formats
    class FV0 < Format
      # Transcode to 320kbps CBR
      def transcode_command
        'Top Kek V0'
      end

      # Locate configuration under key 320
      def key
        'V0'
      end
    end
  end
end
