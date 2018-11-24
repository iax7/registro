# frozen_string_literal: true

# Wraps all the custom queries
class Totals < ApplicationRecord
  require 'queries'

  def self.execute_query(query)
    connection.execute(query).to_a
  end

  def self.people(event_name)
    execute_query Queries.people(event_name)
  end

  def self.offerings(event_name)
    execute_query Queries.offerings(event_name)
  end

  def self.services(event_name)
    execute_query Queries.services(event_name)
  end

  def self.food_by_age_paid_status(event_name)
    execute_query Queries.food_by_age_paid_status(event_name)
  end

  def self.food_used_by_age(event_name)
    execute_query Queries.food_used_by_age(event_name)
  end

  def self.lodging_by_age_sex(event_name)
    execute_query Queries.lodging_by_age_sex(event_name)
  end

  def self.pay_collectors(event_name)
    execute_query Queries.pay_collectors(event_name)
  end

  def self.list_lodging(event_name)
    execute_query Queries.list_lodging(event_name)
  end

  def self.sum_hash(array_of_hash)
    array_of_hash.inject { |init, e| init.merge(e) { |_k, old_v, new_v| old_v + new_v } }
  end
end
