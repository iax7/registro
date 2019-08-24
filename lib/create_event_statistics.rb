# frozen_string_literal: true

require 'totals_helper'

class CreateEventStatistics
  class << self
    def calculate(event_name, save: true)
      event = Event.find_by_name event_name

      # Totals
      people = Totals.people(event_name)
      offerings = Totals.offerings(event_name)
      services = Totals.services(event_name)
      lodging = Totals.lodging_by_age_sex(event_name)

      # Food Totals
      helper = TotalsHelper.new(event.food_full_price, event.food_half_price)
      foods = Totals.food_by_age_paid_status(event_name)
      used = Totals.food_used_by_age(event_name)
      totals_food = helper.process foods, used

      statistics = {
        people: people,
        offerings: offerings,
        services: services,
        lodging: lodging,
        totals_food: totals_food
      }
      return statistics unless save

      event.statistics = statistics
      event.save
    end
  end
end
