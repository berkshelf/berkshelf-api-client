module Berkshelf
  # Used to communicate with a remotely hosted [Berkshelf API Server](https://github.com/berkshelf/berkshelf-api).
  #
  # @example
  #   client = Berkshelf::APIClient.new("https://api.berkshelf.com")
  #   client.universe #=> [...]
  module APIClient
    require_relative 'api_client/version'
    require_relative 'api_client/errors'
    require_relative 'api_client/remote_cookbook'
    require_relative 'api_client/connection'

    class << self
      def new(*args)
        Connection.new(*args)
      end
    end
  end
end
