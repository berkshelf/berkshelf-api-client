
module Berkshelf::APIClient
  require_relative 'errors'

  class ChefServerConnection
    attr_reader :client

    def initialize(*args)
      @client = Ridley.new(*args)
      @url = args[0][:server_url]
    end

    def universe
      response = client.universe

      [].tap do |cookbooks|
        response.each do |name, versions|
          versions.each { |version, attributes|
            attributes[:location_path] = @url
            cookbooks << RemoteCookbook.new(name, version, attributes) }
        end
      end
    rescue Ridley::Errors::HTTPNotFound
      raise ServiceNotFound, "service not found at: #{url}"
    end
  end
end
