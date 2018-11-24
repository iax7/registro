# frozen_string_literal: true

# Shows Front page, and let's encrypt validation
class MainController < ApplicationController
  def index
    @event = Event.current

    # flash.notice = "Test notice"
    # flash.alert = "Test Alert!!!!"
  end

  def letsencrypt
    render plain: Rails.configuration.app[:letsencrypt]
  end
end
