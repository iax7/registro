# frozen_string_literal: true

json.array! @registries, partial: "registries/registry", as: :registry
