PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")

Dir[Padrino.root('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

def app(app = nil &blk)
  @app ||= block_given? ? app.instance_eval(&blk) : app
  @app ||= Padrino.application
end
