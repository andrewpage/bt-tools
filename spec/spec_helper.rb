# Test Coverage Reporting
require 'codeclimate-test-reporter'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

# Require core libs
require 'tools'
# CLI Testing
require 'aruba/api'
# Interactive Console
require 'pry'

RSpec.configure do |config|
  config.include Aruba::Api

  config.color = true

  config.formatter = :documentation

  config.before(:each, shell: true) do
    @aruba_timeout_seconds = 180
    clean_current_dir
  end

  config.after(:each, shell: true) do
    restore_env
    clean_current_dir
  end
end

def mock_configuration
  {
    "create" => {
      "manifest" => "create.json",
      "source" => "/media/sdaa1/pageandrew/private/rtorrent/data",
      "output" => "/media/sdaa1/pageandrew/private/rtorrent/torrents",
      "announceURL" => "http://tracker.what.cd:34000/TEST/announce",
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
