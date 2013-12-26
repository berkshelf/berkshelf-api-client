require 'rubygems'
require 'bundler'
require 'rspec'
require 'spork'
require 'berkshelf/api/rspec'

Spork.prefork do
  Dir[File.join(File.expand_path("../../spec/support/**/*.rb", __FILE__))].each { |f| require f }

  RSpec.configure do |config|
    config.include Berkshelf::API::RSpec

    config.expect_with :rspec do |c|
      c.syntax = :expect
    end

    config.mock_with :rspec
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.filter_run focus: true
    config.run_all_when_everything_filtered = true

    config.before(:suite) { Berkshelf::API::RSpec::Server.start }
    config.before(:all) { Berkshelf::API::Logging.init(location: '/dev/null') }
  end
end

Spork.each_run do
  require 'berkshelf/api-client'
end
