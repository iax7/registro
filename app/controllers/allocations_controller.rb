class AllocationsController < ApplicationController
  before_action :set_allocation, only: [:index, :update ]

  def index
    if is_admin
      @allocations = Allocation.has_allocation
      count_sex = Person.count_by_allocation_sex
      @count_sex = count_sex.first 2
      count_age = Person.count_by_age
      @count_age = count_age.first 2
    else
      redirect_to controller: :people,
                  action: :show
    end
  end

  def new
    @allocation = Allocation.new
  end

  def edit
    if is_admin
      set_allocation
      return
    end

    is_allowed, messages = should_allocation_active
    unless is_allowed
      messages.each_with_index do |msg, index|
        flash["error#{index}"] = msg
      end
      redirect_to view_person_url
      return
    end
    set_allocation
  end

  def create
    @allocation = Allocation.new(allocation_params)
    respond_to do |format|
      if @allocation.save
        format.html { redirect_to view_person_url, notice: 'Hospedaje creado con éxito.' }
        format.json { render :index, status: :created, location: @allocation }
      else
        format.html { render :new }
        format.json { render json: @allocation.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @allocation.update(allocation_params)
        format.html { person_services_redirect @allocation.person_id, 'Hospedaje', 'actualizado' }
        format.json { render :index, status: :ok, location: @allocation }
      else
        format.html { render :edit }
        format.json { render json: @allocation.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_allocation
      id = is_admin ? params[:id].to_i : session_id

      @allocation = Allocation.find_by_person_id(id)
      if @allocation.nil?
        @allocation = Allocation.new
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def allocation_params
      params.require(:allocation).permit( :n1,
                                          :n2,
                                          :n3,
                                          :option
                                        )
    end
end