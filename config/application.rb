require File.expand_path('../boot', __FILE__)

require 'csv'
require 'rails/all'
require 'yaml'
require 'ostruct'

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
    config.i18n.default_locale = 'es-MX'

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    #Custom error pages
    config.exceptions_app = self.routes

    config.action_view.field_error_proc = Proc.new { |html_tag, instance|
      #"<div class=\"form-group has-error\">#{html_tag}</div>".html_safe
      %Q(<div class="has-error">#{html_tag}</div>).html_safe
    }

    # Custom Values ------------------------------------------------------
    Time.zone = config.time_zone
    yml_config = YAML.load_file 'config/app_config.yml'

    #yml_config.each do |k,v|
    #  if v.class == Time
    #    zoneless = Time.zone.local_to_utc(v).strftime '%F %T'
    #    yml_config[k] = Time.zone.parse zoneless
    #  end
    #end
    app_config = OpenStruct.new yml_config

    #config.test_version = false
    config.reg_event_id = app_config.event_id
    config.reg_schedule_show = app_config.schedule_show
    config.reg_schedule = app_config.schedule
    config.reg_transport_schedule = app_config.transport_schedule
    config.reg_main_phone_sched = app_config.main_phone_sched
    config.reg_main_phone = app_config.main_phone
    config.reg_main_email = app_config.main_email
    config.reg_event_name = app_config.event_name
    config.reg_event_title = app_config.event_title
    config.reg_event_subtitle = app_config.event_subtitle
    config.reg_event_dates = app_config.event_dates
    config.reg_adult_age = app_config.adult_age
    config.reg_event_full_price = app_config.event_full_price
    config.reg_food_full_price = app_config.food_full_price
    config.reg_food_half_price = app_config.food_half_price
    config.reg_allocation_full_price = app_config.allocation_full_price
    config.reg_allocation_half_price = app_config.allocation_half_price
    config.reg_transport_full_price = app_config.transport_full_price
    config.reg_max_allocation_men = app_config.max_allocation_men
    config.reg_max_allocation_women = app_config.max_allocation_women
    config.reg_max_food = app_config.max_food
    config.reg_max_people = app_config.max_people
    config.reg_registration_starts = Time.zone.parse app_config.registration_starts
    config.reg_registration_deadline_show = app_config.registration_deadline_show
    config.reg_registration_deadline = Time.zone.parse app_config.registration_deadline
    config.reg_food_deadline = Time.zone.parse app_config.food_deadline
    config.reg_allocation_deadline = Time.zone.parse app_config.allocation_deadline
    config.reg_transport_deadline = Time.zone.parse app_config.transport_deadline
    config.reg_event_ends = Time.zone.parse app_config.event_ends
    config.reg_paycollectors = app_config.paycollectors
    config.reg_location_mapslnk = app_config.location_mapslnk
    config.dektop_app_url = app_config.dektop_app_url
    config.api_user = app_config.api_user
    config.api_pass = app_config.api_pass
    config.reg_site_author = app_config.site_author
    config.reg_site_home_url = app_config.site_home_url
    config.reg_weather_url = app_config.weather_url

    puts "registration_starts:   #{config.reg_registration_starts.to_formatted_s :rfc822 }"
    puts "registration_deadline: #{config.reg_registration_deadline.to_formatted_s :rfc822 }"
    puts "food_deadline:         #{config.reg_food_deadline.to_formatted_s :rfc822 }"
    puts "allocation_deadline:   #{config.reg_allocation_deadline.to_formatted_s :rfc822 }"
    puts "transport_deadline:    #{config.reg_transport_deadline.to_formatted_s :rfc822 }"
    puts "event_ends:            #{config.reg_event_ends.to_formatted_s :rfc822 }"
    puts '-----------------------------------------------------------'
  end
end
