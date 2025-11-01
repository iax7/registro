class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  protect_from_forgery with: :exception # ,  unless: -> { request.format.json? }

  helper_method :confirm_logged_in,
                :start_path,
                :require_admin

  private

  def confirm_logged_in
    return if session[:user_id]

    session[:return_to] = request.fullpath
    flash[:error] = t("application.confirm_logged_in.error")
    redirect_to login_path
    # redirect_to prevents requested action from running
  end

  def start_path
    if helpers.session_active?
      url_for session[:return_to] = nil
      url_for registry_path(session[:reg_id])
    else
      url_for root_url
    end
  end

  def require_admin
    return if session[:is_admin]

    flash[:error] = t("application.require_admin.error")
    redirect_to start_path
  end
end
