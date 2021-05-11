# frozen_string_literal: true

# Handles the Client API page
class ApiuiController < ApplicationController
  before_action :confirm_logged_in
  before_action :require_admin

  layout "apiui_base"

  def index
    @event = Event.current
  end
end
