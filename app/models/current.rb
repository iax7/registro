# frozen_string_literal: true

# Abstract super class that provides a thread-isolated attributes singleton,
# which resets automatically before and after each request.
# This allows you to keep all the per-request attributes easily available to the whole system
class Current < ActiveSupport::CurrentAttributes
  attribute :user
  attribute :event
end
