require "base64"
require "cgi"
require "excon"
require "multi_json"
require "securerandom"
require "uri"
require "zlib"

__LIB_DIR__ = File.expand_path(File.join(File.dirname(__FILE__), ".."))
unless $LOAD_PATH.include?(__LIB_DIR__)
  $LOAD_PATH.unshift(__LIB_DIR__)
end

require "hilarity/api/errors"
require "hilarity/api/mock"
require "hilarity/api/version"

require "hilarity/api/addons"
require "hilarity/api/apps"
require "hilarity/api/attachments"
require "hilarity/api/collaborators"
require "hilarity/api/config_vars"
require "hilarity/api/domains"
require "hilarity/api/features"
require "hilarity/api/keys"
require "hilarity/api/login"
require "hilarity/api/logs"
require "hilarity/api/processes"
require "hilarity/api/releases"
require "hilarity/api/ssl_endpoints"
require "hilarity/api/stacks"
require "hilarity/api/user"

srand

module Hilarity
  class API

    HEADERS = {
      'Accept'                => 'application/json',
      'Accept-Encoding'       => 'gzip',
      #'Accept-Language'       => 'en-US, en;q=0.8',
      'User-Agent'            => "hilarity-rb/#{Hilarity::API::VERSION}",
      'X-Ruby-Version'        => RUBY_VERSION,
      'X-Ruby-Platform'       => RUBY_PLATFORM
    }

    OPTIONS = {
      :headers  => {},
      :host     => 'hilarity.io',
      :nonblock => false,
      :scheme   => 'https'
    }

    def initialize(options={})
      options = OPTIONS.merge(options)

      @api_key = options.delete(:api_key) || ENV['HILARITY_API_KEY']
      if !@api_key && options.has_key?(:username) && options.has_key?(:password)
        username = options.delete(:username)
        password = options.delete(:password)
        @connection = Excon.new("#{options[:scheme]}://#{options[:host]}", options.merge(:headers => HEADERS))
        @api_key = self.post_login(username, password).body["api_key"]
      end

      user_pass = ":#{@api_key}"
      options[:headers] = HEADERS.merge({
        'Authorization' => "Basic #{Base64.encode64(user_pass).gsub("\n", '')}",
      }).merge(options[:headers])

      @connection = Excon.new("#{options[:scheme]}://#{options[:host]}", options)
    end

    def request(params, &block)
      begin
        response = @connection.request(params, &block)
      rescue Excon::Errors::HTTPStatusError => error
        klass = case error.response.status
          when 401 then Hilarity::API::Errors::Unauthorized
          when 402 then Hilarity::API::Errors::VerificationRequired
          when 403 then Hilarity::API::Errors::Forbidden
          when 404
            if error.request[:path].match /\/apps\/\/.*/
              Hilarity::API::Errors::NilApp
            else
              Hilarity::API::Errors::NotFound
            end
          when 408 then Hilarity::API::Errors::Timeout
          when 422 then Hilarity::API::Errors::RequestFailed
          when 423 then Hilarity::API::Errors::Locked
          when 429 then Hilarity::API::Errors::RateLimitExceeded
          when /50./ then Hilarity::API::Errors::RequestFailed
          else Hilarity::API::Errors::ErrorWithResponse
        end

        decompress_response!(error.response)
        reerror = klass.new(error.message, error.response)
        reerror.set_backtrace(error.backtrace)
        raise(reerror)
      end

      if response.body && !response.body.empty?
        decompress_response!(response)
        begin
          response.body = MultiJson.load(response.body)
        rescue
          # leave non-JSON body as is
        end
      end

      # reset (non-persistent) connection
      @connection.reset

      response
    end

    private

    def decompress_response!(response)
      return unless response.headers['Content-Encoding'] == 'gzip'
      response.body = Zlib::GzipReader.new(StringIO.new(response.body)).read
    end

    def app_params(params)
      app_params = {}
      params.each do |key, value|
        app_params["app[#{key}]"] = value
      end
      app_params
    end

    def addon_params(params)
      params.inject({}) do |accum, (key, value)|
        accum["config[#{key}]"] = value
        accum
      end
    end

    def escape(string)
      CGI.escape(string).gsub('.', '%2E')
    end

    def ps_options(params)
      if ps_env = params.delete(:ps_env) || params.delete('ps_env')
        ps_env.each do |key, value|
          params["ps_env[#{key}]"] = value
        end
      end
      params
    end

  end
end
