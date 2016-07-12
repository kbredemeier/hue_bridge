$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'vcr'
require 'hue_bridge'

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :webmock
end
