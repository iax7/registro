# frozen_string_literal: true

# Wraps all the custom queries
class Totals < ApplicationRecord
  require 'queries'

  class << self
    def people(event_name)
      execute_query Queries.people(event_name)
    end

    def offerings(event_name)
      execute_query Queries.offerings(event_name)
    end

    def services(event_name)
      execute_query Queries.services(event_name)
    end

    def food_by_age_paid_status(event_name)
      execute_query Queries.food_by_age_paid_status(event_name)
    end

    def food_used_by_age(event_name)
      execute_query Queries.food_used_by_age(event_name)
    end

    def lodging_by_age_sex(event_name)
      execute_query Queries.lodging_by_age_sex(event_name)
    end

    def pay_collectors(event_name)
      execute_query Queries.pay_collectors(event_name)
    end

    def user_payments(event_name)
      execute_query Queries.user_payments(event_name)
    end

    def list_lodging(event_name)
      execute_query Queries.list_lodging(event_name)
    end

    def sum_hash(array_of_hash)
      array_of_hash.inject { |init, e| init.merge(e) { |_k, old_v, new_v| old_v + new_v } }
    end

    private

    def execute_query(query)
      connection.execute(query).to_a
    end
  end
end
