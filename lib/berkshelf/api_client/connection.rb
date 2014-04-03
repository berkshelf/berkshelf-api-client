require 'faraday'

module Berkshelf::APIClient
  require_relative 'errors'

  class Connection < Faraday::Connection
    # @return [String]
    attr_reader :url

    # @return [Integer]
    #   how many retries to attempt on HTTP requests
    attr_reader :retries

    # @return [Float]
    #   time to wait between retries
    attr_reader :retry_interval

    # @param [String, Addressable::URI] url
    #
    # @option options [Integer] :open_timeout (3)
    #   how long to wait (in seconds) for connection open to the API server
    # @option options [Integer] :timeout (30)
    #   how long to wait (in seconds) before getting a response from the API server
    # @option options [Integer] :retries (3)
    #   how many retries to perform before giving up
    # @option options [Float] :retry_interval (0.5)
    #   how long to wait (in seconds) between each retry
    def initialize(url, options = {})
      options         = options.reverse_merge(retries: 3, retry_interval: 0.5,
        open_timeout: 3, timeout: 30)
      @url            = url
      @retries        = options.delete(:retries)
      @retry_interval = options.delete(:retry_interval)

      options[:builder] ||= Faraday::RackBuilder.new do |b|
        b.response :parse_json
        b.response :gzip
        b.request :retry,
          max: self.retries,
          interval: self.retry_interval,
          exceptions: [
            Faraday::Error::TimeoutError,
            Errno::ETIMEDOUT
          ]

        b.adapter :net_http
      end

      open_timeout = options.delete(:open_timeout)
      timeout      = options.delete(:timeout)
      super(self.url, options)
      @options[:open_timeout] = open_timeout
      @options[:timeout]      = timeout
    end

    # Retrieves the entire universe of known cookbooks from the API source
    #
    # @raise [APIClient::TimeoutError]
    #
    # @return [Array<APIClient::RemoteCookbook>]
    def universe
      response = get("universe")

      case response.status
      when 200
        [].tap do |cookbooks|
          response.body.each do |name, versions|
            versions.each { |version, attributes| cookbooks << RemoteCookbook.new(name, version, attributes) }
          end
        end
      when 404
        raise ServiceNotFound, "service not found at: #{url}"
      when 500..504
        raise ServiceUnavaiable, "service unavailable at: #{url}"
      else
        raise BadResponse, "bad response #{response.inspect}"
      end
    rescue Faraday::Error::TimeoutError, Errno::ETIMEDOUT
      raise TimeoutError, "Unable to connect to: #{url}"
    rescue Faraday::Error::ConnectionFailed => ex
      raise ServiceUnavaiable, ex
    end
  end
end
