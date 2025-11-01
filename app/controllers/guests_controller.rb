# frozen_string_literal: true

# Handles Guest Model
class GuestsController < ApplicationController
  before_action :confirm_logged_in
  before_action :require_admin, only: [:index]
  before_action :set_guest, only: [:show, :edit, :update, :destroy]

  # GET /guests
  # GET /guests.json
  def index
    @guests = Guest.all
  end

  # GET /guests/1
  # GET /guests/1.json
  def show; end

  # GET /guests/new
  def new
    @guest = Guest.new
    @guest_history = User.where(id: helpers.session_id).pluck(:guest_history).first
  end

  # GET /guests/1/edit
  def edit; end

  # POST /guests
  # POST /guests.json
  def create
    @guest = Guest.new(guest_params)

    respond_to do |format|
      if @guest.save
        format.html { redirect_to define_redirection_create_update, notice: t(".notice") }
        format.json { render :show, status: :created, location: @guest }
      else
        flash.alert = t "common.error_create"
        format.html { render :new }
        format.json { render json: @guest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /guests/1
  # PATCH/PUT /guests/1.json
  def update
    respond_to do |format|
      if @guest.update(guest_params)
        format.html { redirect_to define_redirection_create_update, notice: t(".notice") }
        format.json { render :show, status: :ok, location: @guest }
      else
        flash.alert = t "common.error_update"
        format.html { render :edit }
        format.json { render json: @guest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /guests/1
  # DELETE /guests/1.json
  def destroy
    @guest.destroy
    respond_to do |format|
      format.html { redirect_to start_path, notice: t(".notice") }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_guest
    @guest = Guest.find params[:id]
  end

  def define_redirection_create_update
    is_same_registry = @guest.registry_id == session[:reg_id]
    if helpers.admin?
      start_path if is_same_registry
      registry_path @guest.registry_id
    else
      start_path
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def guest_params
    is_new = params[:guest][:registry_id].empty?
    params[:guest][:relation] = params[:guest][:relation].to_i

    if helpers.admin?
      params[:guest][:registry_id] = params[:registry_id] if is_new
    else
      params[:guest][:registry_id] = session[:reg_id]
    end

    params.expect(guest: %i[registry_id
                            name lastname nick is_male age
                            relation is_pregnant is_medicated
                            f_v1 f_v2 f_v3
                            f_s1 f_s2 f_s3
                            f_d1 f_d2 f_d3
                            f_l1 f_l2 f_l3
                            t_v1 t_v2
                            t_s1 t_s2
                            t_d1 t_d2
                            t_l1 t_l2
                            l_v l_s l_d l_l
                            l_room
                            fu_v1 fu_v2 fu_v3
                            fu_s1 fu_s2 fu_s3
                            fu_d1 fu_d2 fu_d3
                            fu_l1 fu_l2 fu_l3
                            tu_v1 tu_v2
                            tu_s1 tu_s2
                            tu_d1 tu_d2
                            tu_l1 tu_l2
                            lu_v
                            lu_s
                            lu_d
                            lu_l])
  end
end
