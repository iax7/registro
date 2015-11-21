class FoodsController < ApplicationController
  before_action :set_food, only: [ :update ]

  def index
    redirect_to controller: :people,
                action: :show
  end

  def new
    @food = Food.new
  end

  def edit
    if is_admin
      set_food
      return
    end

    is_allowed, messages = should_food_active
    unless is_allowed
      messages.each_with_index do |msg, index|
        flash["error#{index}"] = msg
      end
      redirect_to view_person_url
      return
    end
    set_food
  end

  def create
    @food = Food.new(food_params)
    respond_to do |format|
      if @food.save
        format.html { redirect_to view_person_url, notice: 'Alimentos creados con éxito.' }
        format.json { render :index, status: :created, location: @food }
      else
        format.html { render :new }
        format.json { render json: @food.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @food.update(food_params)
        format.html { person_services_redirect @food.person_id, 'Alimentos', 'actualizado' }
        format.json { render :index, status: :ok, location: @food }
      else
        format.html { render :edit }
        format.json { render json: @food.errors, status: :unprocessable_entity }
      end
    end
  end

  def totals
    full = Rails.application.config.reg_food_full_price
    half = Rails.application.config.reg_food_half_price
    return unless require_admin
    per = params[:percent]
    percent = per =~ /^[0-9]$/ ? "0.#{per}" : '0.9'
    @percent = percent.to_s[-1]
    children_regex = /[vsdl][0-3]c/
    adults_regex = /[vsdl][0-3]/
    all_regex = /[vsdl][0-3]c*/

    monetize_attr = lambda do |obj|
      new = obj.dup
      new.attributes.each do |key,value|
        new[key] = value * full if key =~ adults_regex
        new[key] = value * half if key =~ children_regex
      end
      return new
    end
    grand_total = lambda do |obj|
      total = 0
      obj.attributes.each do |key,value|
        total += value if key =~ all_regex
      end
      total
    end

    begin
      food_all = Food.sum_all.first
      food_confirmed = Food.sum_confirmed.first

      food_diff = food_all.dup
      food_diff.attributes.each do |key, value|
        food_diff[key] -= food_confirmed[key] if key =~ all_regex
      end

      food_percent = food_diff.dup
      food_percent.attributes.each do |key, value|
        food_percent[key] *= percent.to_d if key =~ all_regex
      end

      @food_all = food_all
      @food_confirmed = food_confirmed
      @food_diff = food_diff
      @food_percent = food_percent
      @food_real = Foodreal.sum_all.first

      @food_all_money = monetize_attr.call food_all
      @food_confirmed_money = monetize_attr.call food_confirmed
      @food_diff_money = monetize_attr.call food_diff
      @food_percent_money = monetize_attr.call food_percent
      @food_real_money = monetize_attr.call @food_real

      @food_all_total = grand_total.call @food_all_money
      @food_confirmed_total = grand_total.call @food_confirmed_money
      @food_diff_total = grand_total.call @food_diff_money
      @food_percent_total = grand_total.call @food_percent_money
      @food_real_total = grand_total.call @food_real_money
    rescue
      #Show blank
      @food_all  = Food.new
      @food_confirmed = Food.new
      @food_diff = Food.new
      @food_percent = Food.new
      @food_real = Food.new
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_food
      @id = is_admin ? params[:id].to_i : session_id

      @food = Food.find_by_person_id(@id)
      if @food.nil?
        @food = Food.new
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def food_params
      params.require(:food).permit( :v1, :v1c,
                                    :v2, :v2c,
                                    :v3, :v3c,
                                    :s1, :s1c,
                                    :s2, :s2c,
                                    :s3, :s3c,
                                    :d1, :d1c,
                                    :d2, :d2c,
                                    :d3, :d3c,
                                    :l1, :l1c,
                                    :l2, :l2c,
                                    :l3, :l3c)
    end
end