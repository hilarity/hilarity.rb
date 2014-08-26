require File.expand_path("#{File.dirname(__FILE__)}/../lib/hilarity/api")

require 'rubygems'
gem 'minitest' # ensure we are using the gem version
require 'minitest/autorun'
require 'time'

DATA_PATH = File.expand_path("#{File.dirname(__FILE__)}/data")
MOCK = ENV['MOCK'] != 'false'

def data_site_crt
  @data_site_crt ||= File.read(File.join(DATA_PATH, 'site.crt'))
end

def data_site_key
  @data_site_key ||= File.read(File.join(DATA_PATH, 'site.key'))
end

def hilarity
  # ENV['HEROKU_API_KEY'] used for :api_key
  Hilarity::API.new(:mock => MOCK)
end

def random_domain
  "#{random_name}.com"
end

def random_name
  "hilarity-rb-#{SecureRandom.hex(10)}"
end

def random_email_address
  "email@#{random_name}.com"
end

def with_app(params={}, &block)
  begin
    data = hilarity.post_app(params).body
    @name = data['name']
    ready = false
    until ready
      ready = hilarity.request(:method => :put, :path => "/apps/#{@name}/status").status == 201
    end
    yield(data)
  ensure
    hilarity.delete_app(@name) rescue nil
  end
end
