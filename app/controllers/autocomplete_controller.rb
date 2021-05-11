# frozen_string_literal: true

# Access Location Autocomplete services
class AutocompleteController < ApplicationController
  require "csc"

  def countries
    json = CSC.countries params[:string]
    render json: json
  end

  def states
    json = CSC.states params[:string]
    render json: json
  end

  def cities
    json = CSC.cities params[:string]
    render json: json
  end
end
