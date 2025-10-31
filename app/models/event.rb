# frozen_string_literal: true

# Event Model
class Event < ApplicationRecord
  # Initialize defaults after object built (new or loaded from DB)
  after_initialize :init
  # Keep cache updated when record is changed
  after_commit :update_cache

  has_many :registries

  # Expose some commonly used keys for convenience (kept for compatibility)
  store_accessor :settings,
                 :event_title,
                 :event_subtitle,
                 :event_subtitle2,
                 :event_main_phone,
                 :event_main_email,
                 :event_main_email_name,
                 :event_main_email_subject,
                 :address,
                 :maps_link,
                 :maps_document_link,
                 :weather_link,
                 :transport_map,
                 :registration_starts,
                 :event_ends,
                 :adult_age,
                 :event_full_price,
                 :food_full_price,
                 :food_half_price,
                 :lodging_full_price,
                 :lodging_half_price,
                 :transport_full_price,
                 :transport_half_price,
                 :max_people,
                 :max_food,
                 :max_lodging_men,
                 :max_lodging_women,
                 :paycollectors

  store_accessor :statistics,
                 :people,
                 :offerings,
                 :services,
                 :lodging,
                 :totals_food

  def self.current
    Rails.cache.fetch("Event.current", expires_in: 3.months) do
      Event.find_or_create_by(name: Time.current.year.to_s)
    end
  end

  # @param service [:assist | :food | :lodging | :transport]
  # @param age_type [:adult | :child | :infant]
  # @return [Integer]
  def costs_per_service(service, age_type)
    cost_hash.dig(service, age_type) || 0
  end

  private

  def update_cache
    Rails.cache.write("Event.current_id", id)
    Rails.cache.write("Event.current", self)
  end

  # Build and return the cost lookup hash using current settings.
  # Values are coerced to Integer via #to_i helper.
  #
  # @return [Hash{Symbol => Hash{Symbol => Integer}}]
  def cost_hash
    @cost_hash ||= {
      assist: {
        adult: to_i(settings["event_full_price"]),
        child: 0,
        infant: 0
      },
      food: {
        adult: to_i(settings["food_full_price"]),
        child: to_i(settings["food_half_price"]),
        infant: 0
      },
      lodging: {
        adult: to_i(settings["lodging_full_price"]),
        child: to_i(settings["lodging_half_price"]),
        infant: 0
      },
      transport: {
        adult: to_i(settings["transport_full_price"]),
        child: to_i(settings["transport_half_price"]),
        infant: 0
      }
    }
  end

  # Coerce a value to integer safely (nil -> 0)
  def to_i(value)
    case value
    when nil
      0
    when Integer
      value
    when String
      value.to_i
    else
      value.respond_to?(:to_i) ? value.to_i : 0
    end
  end

  def init
    # --- Statistics Totals (ensure arrays exist)
    statistics["people"]      ||= []
    statistics["offerings"]   ||= []
    statistics["services"]    ||= []
    statistics["lodging"]     ||= []
    statistics["totals_food"] ||= []

    # --- Settings
    self.event_title      ||= "My Title"
    self.event_subtitle   ||= "My Subtitle"
    self.event_subtitle2  ||= "My Subtitle2"
    self.event_main_phone ||= "1234567890"
    self.event_main_email ||= "known@domain.com"
    self.event_main_email_name    ||= "Registration Team"
    self.event_main_email_subject ||= "Information"

    self.registration_starts  ||= Time.now
    self.event_ends           ||= Time.new(Time.now.year, 12, 31)

    self.address              ||= "<strong>Place Name</strong><br>Street #1400<br>CP 12345, City, State."
    self.maps_link            ||= "https://www.google.com.mx/maps"
    self.maps_document_link   ||= ""
    self.weather_link         ||= ""
    self.transport_map        ||= "https://www.google.com.mx/maps"

    self.adult_age            ||= 11
    self.event_full_price     ||= 100
    self.food_full_price      ||= 50
    self.food_half_price      ||= 25
    self.lodging_full_price   ||= 100
    self.lodging_half_price   ||= 50
    self.transport_full_price ||= 20
    self.transport_half_price ||= 10
    self.max_people           ||= 1200
    self.max_food             ||= 500
    self.max_lodging_men      ||= 125
    self.max_lodging_women    ||= 125

    self.paycollectors ||= [
      {
        name: "PayCollector1",
        phone: "1234567890",
        phone_type: "mobile",
        email: "known@domain.com",
        location: "City, ST",
        church: "MyChurch1"
      },
      {
        name: "PayCollector2",
        phone: "1234567890",
        phone_type: "phone",
        email: "known@domain.com",
        location: "City2, ST2",
        church: "MyChurch2"
      }
    ]
  end
end
