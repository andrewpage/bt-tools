require 'fileutils'

module Tools
  module Actions
    class Transcode
      include Execution

      def initialize(directory, formats = %w(V0 V2 320))
        @directory = directory
        @formats = formats
      end

      def execute
        directory = @directory

        @formats.each do |bit|
          new_directory = copy_directory(directory, bit)

          Dir.chdir(new_directory) do
            Dir['*.flac'].each do |file|
              transcode(file, bit)
              FileUtils.rm(file)
            end
          end
        end
      end

      private

      def copy_directory(directory, bit)
        new_directory = directory.gsub(%r{(flac|FLAC)}, bit)

        FileUtils.cp_r(directory, new_directory)

        new_directory
      end

      def transcode(file, bitrate)
        preset = vbr?(bitrate) ? 'V' : 'b'

        cmd = Array.new
        cmd << %(flac)
        cmd << %(-cd)
        cmd << %("#{file}")
        cmd << %(|)
        cmd << %(lame)
        cmd << %(-#{preset})
        cmd << cmd_bitrate(bitrate)
        cmd << %(-)
        cmd << %("#{File.basename(file).split('.')[0]}.mp3")
        cmd = cmd.join(' ')

        execute_command(cmd)
      end

      def vbr?(bitrate)
        bitrate.start_with?('V')
      end

      def cmd_bitrate(bitrate)
        vbr?(bitrate) ? bitrate[1..-1] : bitrate
      end
    end
  end
end
