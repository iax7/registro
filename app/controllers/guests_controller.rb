class GuestsController < ApplicationController
  before_action :set_guest, only: [:show, :edit, :update, :destroy]

  # GET /guests
  # GET /guests.json
  def index
    redirect_to_session
  end

  # GET /guests/1
  # GET /guests/1.json
  def show
  end

  # GET /guests/new
  def new
    set_person
    # if is not admin can't modify another guests
    redirect_to_session unless is_admin
    @guest = @person.guests.new
  end

  # GET /guests/1/edit
  def edit
  end

  # POST /guests
  # POST /guests.json
  def create
    set_person
    @guest = @person.guests.new(guest_params)

    respond_to do |format|
      if @guest.save
        format.html { person_services_redirect @guest.person_id, 'Invitado', 'creado' }
        format.json { render :show, status: :created, location: @guest }
      else
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
        format.html { person_services_redirect @guest.person_id, 'Invitado', 'actualizado' }
        format.json { render :show, status: :ok, location: @guest }
      else
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
      format.html { person_services_redirect @guest.person_id, 'Invitado', 'eliminado' }
      format.json { head :no_content }
    end
  end

  private
    def redirect_to_session
      id = session_id
      return if id == 'redirected'
      if @person.id != id
        redirect_to person_path(session_id)
      end
    end

    def set_person
      person_id = params[:person_id].to_i
      @person = Person.find person_id
    end

    def set_guest
      set_person
      # if is not admin can't modify another guests
      redirect_to_session unless is_admin

      id = params[:id].to_i
      @guest = @person.guests.find id
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def guest_params
      params.require(:guest).permit(:name, :nickname, :relation, :ismale, :age, :person)
    end
end
