require 'fileutils'

module Tools
  class Transcoder
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
      command = Array.new

      preset = vbr?(bitrate) ? 'V' : 'b'

      command << %(flac)
      command << %(-cd)
      command << %("#{file}")
      command << %(|)
      command << %(lame)
      command << %(-#{preset})
      command << cmd_bitrate(bitrate)
      command << %(-)
      command << %("#{File.basename(file).split('.')[0]}.mp3")

      to_exec = command.join(' ')

      puts "Transcoding #{file}"
      %x(#{to_exec})
    end

    def vbr?(bitrate)
      bitrate.start_with?('V')
    end

    def cmd_bitrate(bitrate)
      vbr?(bitrate) ? bitrate[1..-1] : bitrate
    end
  end
end
#
# Dir['/Users/andrewpage/Documents/transcode/*'].each do |dir|
#   Transcoder.new(dir).execute
# end
