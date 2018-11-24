# frozen_string_literal: true

# Handles Event Model
class EventsController < ApplicationController
  before_action :confirm_logged_in
  before_action :require_admin
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
  end

  # GET /events/1
  # GET /events/1.json
  def show
    return unless @event.nil?

    @events = Event.all
    flash.now[:alert] = 'The event was not found'
    render 'index'
  end

  # GET /events/new
  def new
    @event = Event.new
    @event.settings = @event.settings.to_yaml
  end

  # GET /events/1/edit
  def edit
    @event.settings = @event.settings.to_yaml
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    # Fix Rails Saving the Hash as String in the DB
    #                           eval params[:event][:settings] Direct Ruby Text Hash
    @event.assign_attributes event_params
    @event.settings = YAML.safe_load @event.settings

    respond_to do |format|
      if @event.save
        # Update MemCache
        Rails.configuration.appcache.write 'Event.current', @event
        Rails.configuration.appcache.read 'Event.current'
        logger.info "*** Event: #{@event.name} changed. Event in cache was updated."

        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find_by(id: params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(:name,
                                  :f_v1, :f_v2, :f_v3,
                                  :f_s1, :f_s2, :f_s3,
                                  :f_d1, :f_d2, :f_d3,
                                  :f_l1, :f_l2, :f_l3,
                                  :t_v, :t_s, :t_d, :t_l,
                                  :l_v, :l_s, :l_d, :l_l,
                                  :settings)
  end
end
