# config/application.rb
require_relative "boot"
require "rails"
require "active_model/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require 'statsd-instrument'

require "dotenv" 
Dotenv.load   

module PaymentProcessor
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Only loads a smaller set of middleware suitable for API only apps.
    config.api_only = true

    # Configure logger
    config.logger = Logger.new(STDOUT)
    config.log_level = :info

    # Configure timezone
    config.time_zone = 'UTC'
  end
end