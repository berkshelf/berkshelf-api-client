require 'chef/server_api'
require 'chef/http/simple_json'
require 'chef/http/simple'

module Berkshelf
  module RidleyCompatAPI
    def initialize(**opts)
      opts = opts.dup
      opts[:ssl] ||= {}
      chef_opts = {
        rest_timeout: opts[:timeout], # opts[:open_timeout] is ignored on purpose
        client_name: opts[:client_name],
        signing_key_filename: opts[:client_key],
        ssl_verify_mode: opts[:verify] ? :verify_none : :verify_peer,
        ssl_ca_path: opts[:ssl][:ca_path],
        ssl_ca_file: opts[:ssl][:ca_file],
        ssl_client_cert: opts[:ssl][:client_cert],
        ssl_client_key: opts[:ssl][:client_key],
      }
      super(opts[:server_url], **chef_opts)
    end

    def get(url)
      super(url)
    end
  end

  class RidleyCompatSimple < Chef::ServerAPI
    use Chef::HTTP::Decompressor
    use Chef::HTTP::CookieManager
    use Chef::HTTP::ValidateContentLength

    include RidleyCompatAPI
  end

  class RidleyCompatJSON < Chef::HTTP::SimpleJSON
    use Chef::HTTP::JSONInput
    use Chef::HTTP::JSONOutput
    use Chef::HTTP::CookieManager
    use Chef::HTTP::Decompressor
    use Chef::HTTP::RemoteRequestID
    use Chef::HTTP::ValidateContentLength

    include RidleyCompatAPI
  end

  class RidleyCompat < Chef::HTTP::Simple
    use Chef::HTTP::JSONInput
    use Chef::HTTP::JSONOutput
    use Chef::HTTP::CookieManager
    use Chef::HTTP::Decompressor
    use Chef::HTTP::Authenticator
    use Chef::HTTP::RemoteRequestID
    use Chef::HTTP::APIVersions
    use Chef::HTTP::ValidateContentLength

    include RidleyCompatAPI
  end
end
