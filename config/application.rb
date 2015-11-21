require File.expand_path('../boot', __FILE__)

require 'csv'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Reg
  class Application < Rails::Application
    config.assets.paths << "#{Rails}/vendor/assets/fonts"
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'America/Mexico_City'
    config.active_record.default_timezone = :local

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    #Custom error pages
    config.exceptions_app = self.routes

    config.action_view.field_error_proc = Proc.new { |html_tag, instance|
      #"<div class=\"form-group has-error\">#{html_tag}</div>".html_safe
      %Q(<div class="has-error">#{html_tag}</div>).html_safe
    }

    # Custom Values ------------------------------------------------------
    #config.test_version = false
    config.reg_adult_age = 11
    config.reg_food_full_price = 50
    config.reg_food_half_price = 25
    config.reg_allocation_full_price = 100
    config.reg_allocation_half_price = 50
    config.reg_transport_full_price = 20
    config.reg_max_allocation_men = 112
    config.reg_max_allocation_women = 112
    config.reg_max_food = 500
    config.reg_max_people = 1200
    config.reg_registration_deadline_show = false
    config.reg_registration_deadline = DateTime.parse '2015-11-20 00:00:00 CST'
    config.reg_food_deadline = DateTime.parse '2015-11-10 00:00:00 CST'
    config.reg_allocation_deadline = DateTime.parse '2015-11-10 00:00:00 CST'
    config.reg_transport_deadline = DateTime.parse '2015-11-10 00:00:00 CST'
    config.reg_event_ends = DateTime.parse '2015-11-16 14:00:00 CST'
    config.reg_paycollectors = [ {name: 'Person1', phone: '1111111111', email: 'known@email.com', location: 'Guadalajara, JAL', church: 'Known'},
                                 {name: 'Person2', phone: '2222222222', email: 'known@email.com', location: 'Guadalajara, JAL', church: 'Known'},
                                 {name: 'Person3', phone: '3333333333', email: 'known@email.com', location: 'México, DF', church: 'Known'},
                                 {name: 'Person4', phone: '4444444444', email: 'known@email.com', location: 'Querétaro, Qro', church: 'Known'}
                               ]
    config.dektop_app_url = 'https://public_url.com/reg.zip'
    # old -> 'documents/setup.zip'
    config.api_user = 'apiv1user'
    config.api_pass = 'changeme'
  end
end
