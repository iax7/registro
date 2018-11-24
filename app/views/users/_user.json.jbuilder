# frozen_string_literal: true

json.extract! user, :id,
              :name,
              :lastname,
              :nick,
              :email,
              :is_male,
              :phone,
              :is_admin,
              :dob,
              :created_at,
              :updated_at
json.url user_url(user, format: :json)
