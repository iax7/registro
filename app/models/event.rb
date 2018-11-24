# frozen_string_literal: true

# Event Model
class Event < ApplicationRecord
  after_initialize :init

  has_many :registries

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

  validates :f_v1, :f_v2, :f_v3,
            :f_s1, :f_s2, :f_s3,
            :f_d1, :f_d2, :f_d3,
            :f_l1, :f_l2, :f_l3,
            :t_v1, :t_v2,
            :t_s1, :t_s2,
            :t_d1, :t_d2,
            :t_l1, :t_l2,
            :l_v, :l_s, :l_d, :l_l,
            presence: true,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: 0 }

  def self.current
    Rails.configuration.appcache.fetch('Event.current', expires_in: 1.year) do
      Event.find_or_create_by(name: Time.current.year.to_s)
    end
  end

  # @param service [Symbol] :assist, :food, :lodging, :transport
  # @param age_type [Integer] 1 Adult, 0 Child, -1 Infant
  # @return [Integer]
  def costs_per_service(service, age_type)
    @cost_hash[service][age_type]
  end

  private

  def init
    @cost_hash = {
      assist: {
        1  => event_full_price,
        0  => 0,
        -1 => 0
      },
      food: {
        1  => food_full_price,
        0  => food_half_price,
        -1 => 0
      },
      lodging: {
        1  => lodging_full_price,
        0  => lodging_half_price,
        -1 => 0
      },
      transport: {
        1  => transport_full_price,
        0  => transport_half_price,
        -1 => 0
      }
    }

    # Totals
    self.f_v1 ||= 0
    self.f_v2 ||= 0
    self.f_v3 ||= 0
    self.f_s1 ||= 0
    self.f_s2 ||= 0
    self.f_s3 ||= 0
    self.f_d1 ||= 0
    self.f_d2 ||= 0
    self.f_d3 ||= 0
    self.f_l1 ||= 0
    self.f_l2 ||= 0
    self.f_l3 ||= 0
    self.t_v1 ||= 0
    self.t_v2 ||= 0
    self.t_s1 ||= 0
    self.t_s2 ||= 0
    self.t_d1 ||= 0
    self.t_d2 ||= 0
    self.t_l1 ||= 0
    self.t_l2 ||= 0
    self.l_v  ||= 0
    self.l_s  ||= 0
    self.l_d  ||= 0
    self.l_l  ||= 0

    # --- Settings
    self.event_title      ||= 'My Title'
    self.event_subtitle   ||= 'My Subtitle'
    self.event_subtitle2  ||= 'My Subtitle2'
    self.event_main_phone ||= '1234567890'
    self.event_main_email ||= 'known@domain.com'
    self.event_main_email_name    ||= 'Registration Team'
    self.event_main_email_subject ||= 'Information'

    self.registration_starts  ||= Time.now
    self.event_ends           ||= Time.now

    self.address              ||= '<strong>Place Name</strong><br>Street #1400<br>CP 12345, City, State.'
    self.maps_link            ||= 'https://www.google.com.mx/maps'
    self.maps_document_link   ||= ''
    self.weather_link         ||= ''
    self.transport_map        ||= 'https://www.google.com.mx/maps'

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
        name: 'PayCollector1',
        phone: '1234567890',
        phone_type: 'mobile',
        email: 'known@domain.com',
        location: 'City, ST',
        church: 'MyChurch'
      },
      {
        name: 'PayCollector2',
        phone: '1234567890',
        phone_type: 'phone',
        email: 'known@domain.com',
        location: 'City2, ST2',
        church: 'MyChurch2'
      }
    ]
  end
end
