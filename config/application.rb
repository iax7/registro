# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Reg
  # Main Application
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.generators do |g|
      g.javascript_engine :js
      g.test_framework :rspec
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.paths.add 'app/serializers', eager_load: true

    # Custom error pages
    config.exceptions_app = routes

    config.app = config_for(:app).symbolize_keys
    config.appcache = ActiveSupport::Cache::MemoryStore.new
    # Default main url, used specifically for mailer
    Rails.application.routes.default_url_options[:host] = config.app[:default_url]
    puts '-----------------------------------------------------------'
  end
end
