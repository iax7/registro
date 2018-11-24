# frozen_string_literal: true

# Handles User Model
class UsersController < ApplicationController
  before_action :confirm_logged_in, except: [:new, :create]
  before_action :require_admin, except: [:new, :create, :edit, :update]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show; end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit; end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    # Handled in Model => @user.registries = Registry.new

    respond_to do |format|
      if @user.save
        logger.debug "*** User #{@user.name} with id #{@user.id} was created!"
        flash.notice = t('.notice')

        # creating and setting current session active
        helpers.set_session_vars @user.id, @user.is_admin, @user.current.id

        # Send Welcome Email
        UserMailer.welcome(@user).deliver_now

        format.html { redirect_to registry_path(@user.current.id), notice: t('.notice') }
        format.json { render :show, status: :created, location: @user }
      else
        logger.fatal "*** Error creating the User. #{@user.errors.full_messages} ***"
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)

        # update_current_guest_with_relation_me(@user) MOVED TO MODEL
        format.html { redirect_to registry_path(session[:reg_id]), notice: t('.notice') }
        format.json { render :show, status: :ok, location: @user }
      else
        logger.fatal "*** Error updating the User. #{@user.errors.full_messages} ***"
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: t('.notice') }
      format.json { head :no_content }
    end
  end

  def payments
    # unless is_admin
    #  redirect_to action: :show
    # end

    @pay_collectors = Totals.pay_collectors(Event.current.name)
    @sum = @pay_collectors.sum { |p| p['amount'] }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name,
                                 :lastname,
                                 :nick,
                                 :is_male,
                                 :email,
                                 :phone,
                                 :dob,
                                 :country,
                                 :state,
                                 :city,
                                 :password,
                                 :password_confirmation)
  end
end
