# frozen_string_literal: true

# Access Controller
class AccessController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:login, :attempt_login]

  def login; end

  def attempt_login
    params.permit(:email, :password)
    authorized_user = nil

    if params[:email].present? && params[:password].present?
      found_user = User.find_by email: params[:email]
      if found_user
        authorized_user = found_user.authenticate params[:password]
      else
        logger.debug("*** User: #{params[:email]} not found. ***")
      end
    end

    if authorized_user
      logger.debug "*** User (#{authorized_user.id}) #{authorized_user.nick} is logged! ***"

      current_registry = Registry.find_by user_id: authorized_user.id, event_id: Event.current.id

      # Creates new registration if current event is not already created
      # This should be handled in other place, and being redirected there.
      unless current_registry
        logger.debug("*** User has not active registration, creating one...")
        authorized_user.register_current_event!
        current_registry = authorized_user.registries.last
      end

      # JWT Token: Auth.generate_jwt(authorized_user.token_data) <----------------
      helpers.set_session_vars authorized_user.id, authorized_user.is_admin, current_registry.id
      # session[:user_id] = authorized_user.id
      # session[:is_admin] = authorized_user.is_admin
      # session[:reg_id] = current_registry.id

      if session[:return_to]
        redirect_to session[:return_to]
        session[:return_to] = nil
      else
        redirect_to controller: :registries, action: :show, id: session[:reg_id]
      end
    else
      # Incorrect Password
      flash.now.alert = t('.invalid')
      render 'access/login'
    end
  end

  def logout
    if helpers.session_active?
      reset_session
      helpers.set_session_vars nil, nil, nil
    end
    flash.notice = t('.msg')
    redirect_to root_path
  end

  # Step 1
  # POST
  def reset_request
    return if request.get?

    params.permit :email

    return unless params[:email].present?

    found_user = User.find_by_email params[:email]
    if found_user
      found_user.set_password_reset
      logger.info "*** Password reset process started with user #{found_user.id}: #{found_user.email}"
      logger.debug "***   Token: #{found_user.password_reset_token}"
      # This sends an e-mail with a link for the user to reset the password
      UserMailer.reset_password(found_user).deliver
    end
    flash.notice = t('.msg')
    redirect_to root_path
  end

  # GET/POST access/reset
  #  GET is Step 2, validates token and shows change password form
  # POST is Step 3, changes the password
  def reset
    if request.get?
      found_user = User.find_by_password_reset_token(params[:token])
      unless found_user
        flash[:error] = t '.invalid'
        redirect_to login_path
        return false # breaks further executions
      end

      @email = found_user.email

      if found_user.password_reset_sent_at < 2.hours.ago
        flash[:error] = t '.expired'
        redirect_to login_path
      end

    elsif request.post?
      params.permit(:email, :password)
      found_user = User.find_by_email(params[:email])
      found_user.password = params[:password]
      found_user.password_reset_token = nil
      found_user.password_reset_sent_at = nil
      found_user.save
      flash.notice = t '.changed'
      redirect_to root_url
    end
  end
end
