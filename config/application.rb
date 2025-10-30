require_relative "boot"

require "rails/all"
require "ostruct" # TODO: remove after migrating from OpenStruct usage

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Reg
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.generators do |g|
      g.javascript_engine :js
      g.test_framework :rspec
    end

    # Custom error pages
    config.exceptions_app = routes

    config.app = config_for(:app).symbolize_keys
    config.appcache = ActiveSupport::Cache::MemoryStore.new
    # Default main url, used specifically for mailer
    Rails.application.routes.default_url_options[:host] = config.app[:default_url]
  end
end
