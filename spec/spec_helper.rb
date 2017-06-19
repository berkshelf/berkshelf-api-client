require 'rspec'
require 'rspec/its'
require 'webmock/rspec'
require 'berkshelf/api-client'

WebMock.disable_net_connect!(allow_localhost: false)

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
