require 'spork'

PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)

Spork.prefork do
  require 'webmock/rspec'
  require File.expand_path(File.dirname(__FILE__) + "/../config/boot")
  Dir[Padrino.root('spec/support/**/*.rb')].each { |f| require f }

  RSpec.configure do |conf|
    conf.include Rack::Test::Methods
  end

  def app
    Padrino.application
  end
end

Spork.each_run do
end