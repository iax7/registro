# frozen_string_literal: true

json.extract! registry, :id, :user_id, :event_id, :comments, :is_confirmed, :is_present, :is_notified, :amount_debt, :amount_paid, :amount_offering, :created_at, :updated_at
json.url registry_url(registry, format: :json)
