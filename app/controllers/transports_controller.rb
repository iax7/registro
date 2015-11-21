class TransportsController < ApplicationController
  before_action :set_transport, only: [ :update ]

  # GET /transports
  # GET /transports.json
  def index
    if is_admin
      @transports = Transport.has_transport
    else
      redirect_to controller: :people,
                  action: :show
    end
  end

  # GET /transports/1
  # GET /transports/1.json
  #def show
  #end

  # GET /transports/new
  def new
    @transport = Transport.new
  end

  # GET /transports/1/edit
  def edit
    if is_admin
      set_transport
      return
    end

    is_allowed, messages = should_transport_active
    unless is_allowed
      messages.each_with_index do |msg, index|
        flash["error#{index}"] = msg
      end
      redirect_to view_person_url
      return
    end
    set_transport
  end

  # POST /transports
  # POST /transports.json
  def create
    @transport = Transport.new(transport_params)

    respond_to do |format|
      if @transport.save
        format.html { redirect_to view_person_url, notice: 'Transporte creado con éxito.' }
        format.json { render :show, status: :created, location: @transport }
      else
        format.html { render :new }
        format.json { render json: @transport.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transports/1
  # PATCH/PUT /transports/1.json
  def update
    respond_to do |format|
      if @transport.update(transport_params)
        format.html { person_services_redirect @transport.person_id, 'Transporte', 'actualizado' }
        format.json { render :show, status: :ok, location: @transport }
      else
        format.html { render :edit }
        format.json { render json: @transport.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transports/1
  # DELETE /transports/1.json
  #def destroy
  #  @transport.destroy
  #  respond_to do |format|
  #    format.html { redirect_to transports_url, notice: 'Transport was successfully destroyed.' }
  #    format.json { head :no_content }
  #  end
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transport
      id = is_admin ? params[:id].to_i : session_id

      @transport = Transport.find_by_person_id(id)
      if @transport.nil?
        @transport = Transport.new
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transport_params
      params.require(:transport).permit( :v1, :v2, :s1, :s2, :d1, :d2, :l1, :l2)
    end
end
