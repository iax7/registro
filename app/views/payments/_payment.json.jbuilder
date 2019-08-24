# frozen_string_literal: true

json.extract! payment, :id, :registry_id, :user_id, :amount, :type, :created_at, :updated_at
json.url payment_url(payment, format: :json)
