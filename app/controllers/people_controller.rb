class PeopleController < ApplicationController
  before_action :set_person, only: [ :edit, :update ]

  autocomplete :country, :name, :full => true
  autocomplete :church, :name, :full => true
  autocomplete :state, :name, :full => true

  # GET
  def comments
    unless is_admin
      redirect_to action: :show
    end

    @people = Person.with_comments
  end

  # GET /people
  # GET /people.json
  def index
    unless require_admin
      return false
    end

    order = params[:order].nil? ? 'lastname' : params[:order]
    unless Person.column_names.include?(order)
      flash[:error] = "Columna Inválida: #{order}"
      order = ''
    end

    filters = params.slice(:id,
                           :lastname,
                           :church,
                           :city,
                           :state,
                           :changed_by,
                           :is_admin,
                           :is_confirmed,
                           :is_not_confirmed,
                           :is_cancelled)

    if filters.length > 0
      @people = Person.includes(:guests,
                                :food,
                                :allocation,
                                :transport).order(order).where(nil)

      filters.each do |key,value|
        @people = @people.public_send(key, value) if value.present?
      end
    else
      @people = []
    end

    @filters = filters
    session[:admin_filters] = filters

    respond_to do |format|
      format.html
      format.json
      format.csv { send_data @people.to_csv,
                             filename: "registro-#{Date.today}.csv",
                             disposition: 'attachment' }
      format.xls {
        response.headers['Content-Disposition'] = "attachment; filename=\"registro-#{Date.today}.xls\""
      }
    end
  end

  # GET /people/1
  # GET /people/1.json
  def show
    if is_admin
      id = params[:id]
      if id == nil
        id = session_id
      end
      @person = Person.includes(:guests,
                                :food,
                                :allocation,
                                :transport).find(id)
      @is_readonly = true

      male_count = 0
      female_count = 0

      @person.guests.each {|x| x.ismale? ? male_count += 1 : female_count += 1}
      @person.ismale? ? male_count += 1 : female_count += 1

      count_sex = Person.count_by_allocation_sex.first 2

      @female_row = { available: count_sex[0]['remaining'].to_i, requested: female_count }
      @male_row =  { available: count_sex[1]['remaining'].to_i, requested: male_count }
    else
      set_person
    end
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people
  # POST /people.json
  def create
    @person = Person.new(person_params)
    @person.food = Food.new
    @person.allocation = Allocation.new
    @person.transport = Transport.new

    respond_to do |format|
      if @person.save
        # creating and setting current session active
        session[:user_id] = @person.id

        # Check if church exists, if not add it
        Church.check_add(@person.church)

        # Send Welcome Email
        PersonMailer.welcome(@person).deliver_now

        format.html { redirect_to view_person_url, notice: 'Registro creado con éxito.' }
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1
  # PATCH/PUT /people/1.json
  def update
    params.delete :password
    params.delete :password_confirmation

    respond_to do |format|
      if @person.update(person_params)
        Church.check_add(@person.church)
        format.html { person_edit_redirect @person }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  def totals
    unless is_admin
      redirect_to action: :show
    end

    require 'ostruct'
    @people = []
    @offerings = ''
    @food = []
    @allo = []
    @trans = []

    Person.num_registered.each       { |x| @people.append OpenStruct.new(x) }
    Person.offerings.each            { |x| @offerings = x['offerings'] }
    Food.available_totals.each       { |x| @food.append OpenStruct.new(x) }
    Allocation.available_totals.each { |x| @allo.append OpenStruct.new(x) }
    @allo_sex = Person.count_by_allocation_sex
    @allo_age = Person.count_by_age
    Transport.available_totals.each  { |x| @trans.append OpenStruct.new(x) }

    # Total Transport
    trans_temp = @trans.dup
    @trans.clear

    transport_price = Rails.application.config.reg_transport_full_price
    trans_temp.each do |row|
      trans_num = row.v1.to_i + row.v2.to_i +
                               row.s1.to_i + row.s2.to_i +
                               row.d1.to_i + row.d2.to_i +
                               row.l1.to_i + row.l2.to_i
      trans_pri = trans_num * transport_price
      row_temp = row.to_h
      row_temp['price'] = trans_pri
      @trans.append OpenStruct.new(row_temp)
    end

  end

  def payments
    unless is_admin
      redirect_to action: :show
    end

    @people = Person.payments
    @sum = @people.sum { |p| p['paid'].to_i }
  end

  def graphs
    unless is_admin
      redirect_to action: :show
    end

    @graph_by_dow  = convert_to_JSON_series 'Por día'   , Person.graph_by_dow , 2
    @graph_by_week = convert_to_JSON_series 'Por semana', Person.graph_by_week, 4, false
    @graph_by_date = convert_to_JSON_series 'Por fecha' , Person.graph_by_date


    @graph_by_country = convert_to_JSON_series_categories 'Paises'  , Person.graph_by_country, 5
    @graph_by_city    = convert_to_JSON_series_categories 'Ciudades', Person.graph_by_city, 6
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      id = is_admin ? params[:id].to_i : session_id
      if (is_admin and id == 0)
        id = session_id
      end

      if id.is_a? Numeric
        @person = Person.includes(:guests,
                                  :food,
                                  :allocation,
                                  :transport).find(id)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      #params[:person]
      unless is_admin
        params[:person].delete :amount_paid
        params[:person].delete :changed_by
      end

      params.require(:person).permit(:name,
                                     :lastname,
                                     :nickname,
                                     :email,
                                     :phone,
                                     :country,
                                     :state,
                                     :city,
                                     :comments,
                                     :isconfirmed,
                                     :ispresent,
                                     :isnotified,
                                     :password,
                                     :password_confirmation,
                                     :ismale,
                                     :church,
                                     :assist_v,
                                     :assist_s,
                                     :assist_d,
                                     :assist_l,
                                     :age,
                                     :amount_paid,
                                     :changed_by,
                                     :offering
                                    )
    end
end
