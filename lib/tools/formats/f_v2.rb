module Tools
  module Formats
    class FV2 < Format
      # Transcode to 320kbps CBR
      def transcode_command
        'Top Kek V2'
      end

      # Locate configuration under key 320
      def key
        'V2'
      end
    end
  end
end
