$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'tools'
require 'pry'

RSpec.configure do |config|
  config.color = true

  config.formatter = :documentation
end

def mock_configuration
  {
    "create" => {
      "manifest" => "create.json",
      "source" => "/media/sdaa1/pageandrew/private/rtorrent/data",
      "output" => "/media/sdaa1/pageandrew/private/rtorrent/torrents",
      "announceURL" => "http://tracker.what.cd:34000/iaqlcal9wjqzruu6oxjfn84xc38tdfam/announce",
      "private" => "true",
      "pieceSize" => 18
    },
    "transcode" => {
      "formats" => {
        "320" => "transcode-320.json",
        "V0" => "transcode-V0.json",
        "V2" => "transcode-V2.json"
      },
      "source" => "/media/sdaa1/pageandrew/private/rtorrent/data",
      "output" => "/media/sdaa1/pageandrew/private/rtorrent/data"
    }
  }
end

def fixture_path(path)
  File.join(
    'spec',
    'fixtures',
    path
  )
end
