# frozen_string_literal: true

# Handles Registry Model
class RegistriesController < ApplicationController
  before_action :confirm_logged_in
  before_action :require_admin, except: [:show, :edit, :update]

  before_action :set_registry, only: [:edit, :update, :destroy]

  # GET /registries
  # GET /registries.json
  def index
    # ORDER -------------------------------------------------------------
    order = "users.lastname, users.name, users.id"
    if params[:order].present?
      valid_columns = {
        users: User.column_names,
        registries: Registry.column_names,
        guests: Guest.column_names
      }.with_indifferent_access
      table, column = params[:order].include?(".") ? params[:order].split(".") : [:registries, params[:order]]

      if valid_columns[table].include? column
        order = params[:order]
      else
        flash[:error] = "Columna de ordenamiento inválida: #{order}"
      end
    end

    # FILTERS ------------------------------------------------------------
    filters = {
      event_id: Event.current.id
    }
    permitted = params.permit(%i[user_id guest_id name lastname paid_by is_admin is_unpaid is_confirmed]).to_h.symbolize_keys
    number_parameters = permitted.count
    permitted.delete_if { |_, v| v.blank? }

    if permitted.key?(:guest_id)
      ids = Guest.includes(:registry).where(:id => permitted[:guest_id]).pluck(:user_id)
      permitted[:user_id] = ids.first
      logger.debug "*** Converted parameter {:guest_id => #{permitted[:guest_id]}} to {:user_id => #{permitted[:user_id]}}"
    end

    filters[:user_id] = permitted[:user_id] if permitted[:user_id].present?
    filters[:paid_by] = permitted[:paid_by] if permitted[:paid_by].present?
    filters[:users] = { is_admin: permitted[:is_admin] } if permitted[:is_admin].present?
    @filters = filters

    logger.debug "*** Used filters: #{filters}"

    if number_parameters.zero?
      @registries = []
    else
      # EXECUTE ------------------------------------------------------------
      reg = RegistrySearch.main_query
      reg = reg.where("unaccent(users.name) ~* unaccent(?)", permitted[:name].downcase) if permitted[:name].present?
      reg = reg.where("unaccent(users.lastname) ~* unaccent(?)", permitted[:lastname].downcase) if permitted[:lastname].present?
      reg = reg.where("amount_debt + amount_offering <> amount_paid") if permitted[:is_unpaid].present?
      qry = reg.order(order).where(filters).to_sql

      @registries = ActiveRecord::Base.connection.select_all(qry).to_a
    end

    respond_to do |format|
      format.html
      format.json
      format.csv do
        send_data @users.to_csv,
                  filename: "registro-#{Date.today}.csv",
                  disposition: "attachment"
      end
      format.xls do
        response.headers["Content-Disposition"] = %(attachment; filename="registro-#{Date.today}.xls")
      end
    end
  end

  # GET /registries/1
  # GET /registries/1.json
  def show
    id = reg_id
    @registry = Registry.includes(:user, :guests).order("guests.id").find id
    @event = Event.current
  end

  # GET /registries/new
  def new
    @registry = Registry.new
  end

  # GET /registries/1/edit
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /registries
  # POST /registries.json
  def create
    @registry = Registry.new(registry_params)

    respond_to do |format|
      if @registry.save
        format.html { redirect_to @registry, notice: "Registry was successfully created." }
        format.json { render :show, status: :created, location: @registry }
      else
        format.html { render :new }
        format.json { render json: @registry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /registries/1
  # PATCH/PUT /registries/1.json
  def update
    respond_to do |format|
      updated = nil
      is_payment_update = params["registry"]["paid_by"].present? && params["payment"]["amount"].present?
      if is_payment_update
        payment_permitted = params.require(:payment).permit(:amount, :kind).to_hash.symbolize_keys
        amount, kind = payment_permitted.values_at(:amount, :kind)

        registry_permitted = registry_params
        registry_permitted["amount_paid"] = @registry.amount_paid + amount.to_i

        Registry.transaction do
          updated = @registry.update(registry_permitted)
          create_payment(paid_by: registry_permitted["paid_by"], amount: amount, kind: kind)
        end
      else
        updated = @registry.update(registry_params)
      end

      if updated
        format.html { redirect_to @registry, notice: "Registry was successfully updated." }
        format.js
        format.json { render :show, status: :ok, location: @registry }
      else
        format.html { render :edit }
        format.json { render json: @registry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /registries/1
  # DELETE /registries/1.json
  def destroy
    @registry.destroy
    respond_to do |format|
      format.html { redirect_to registries_url, notice: "Registry was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def list_lodging
    @guests = Guest.includes(:registry => :user)
                   .where(registries: { event_id: Event.current.id })
                   .where("l_v or l_s or l_d or l_l")
                   .order("registry_id, relation, age desc")
                   .all
  end

  def list_transport
    @guests = Guest.includes(:registry => :user)
                   .where(registries: { event_id: Event.current.id })
                   .where("t_v1 or t_v2 or t_s1 or t_s2 or t_d1 or t_d2 or t_l1 or t_l2")
                   .order("guests.lastname")
                   .all
  end

  def totals
    if params[:name]
      event = Event.find_by_name params[:name]
      redirect_to(totals_registries_path, alert: "Error, event #{params[:name]} was not found.") && return unless event

      @people = event.people
      @offerings = event.offerings
      @services = event.services
      @lodging = event.lodging
    else
      @people = Totals.people(Event.current.name)
      @offerings = Totals.offerings(Event.current.name)
      @services = Totals.services(Event.current.name)
      @lodging = Totals.lodging_by_age_sex(Event.current.name)
    end
  end

  def totals_food
    if params[:name]
      event = Event.find_by_name params[:name]
      redirect_to(totals_food_registries_path, alert: "Error, event #{params[:name]} was not found.") && return unless event

      @totals_food = event.totals_food.deep_symbolize_keys
    else
      require "totals_helper"

      helper = TotalsHelper.new(Event.current.food_full_price, Event.current.food_half_price)
      foods = Totals.food_by_age_paid_status(Event.current.name)
      used = Totals.food_used_by_age(Event.current.name)

      @totals_food = helper.process foods, used
    end
  end

  def edit_payment
    @registry = Registry.find(params[:registry_id])
    respond_to do |format|
      format.js
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def reg_id
    if helpers.admin? && (params.key? :id)
      params[:id]
    else
      helpers.session_reg
    end
  end

  def set_registry
    id = reg_id
    @registry = Registry.find id
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def registry_params
    unless helpers.admin?
      params[:registry].delete :amount_paid
      params[:registry].delete :paid_by
      params[:registry].delete :type
    end

    params.require(:registry).permit(:user_id, :event_id, :comments, :is_confirmed, :is_present,
                                     :is_notified, :amount_debt, :amount_paid, :amount_offering, :paid_by)
  end

  def create_payment(paid_by:, amount:, kind:)
    Payment.create(registry: @registry,
                   user_id: paid_by,
                   amount: amount,
                   kind: kind)
    logger.debug "  *** Payment created for registry [#{@registry.id}], Received by: #{@registry.paid_by} => #{amount} / #{kind}"
  rescue StandardError
    logger.error "  *** Err! Payment log was not created for [#{@registry.id}], Received by: #{@registry.paid_by} => #{amount} / #{kind}"
  end
end
