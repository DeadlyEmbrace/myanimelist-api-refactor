require 'simplecov'
require 'webmock/rspec'

PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")

Dir[Padrino.root('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

def app
  Padrino.application
end
