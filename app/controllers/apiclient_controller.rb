class ApiclientController < ApplicationController
  before_action :require_admin

  def ui
    render layout: 'api_client'
  end
end
