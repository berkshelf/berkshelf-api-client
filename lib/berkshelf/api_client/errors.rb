module Berkshelf
  class APIClientError < StandardError; end

  module APIClient
    class TimeoutError < APIClientError; end
    class BadResponse < APIClientError; end
    class ServiceUnavaiable < APIClientError; end
    class ServiceNotFound < APIClientError; end
  end
end
