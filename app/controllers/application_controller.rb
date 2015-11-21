class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :set_active,
                :is_session_active,
                :session_id,
                :get_start,
                :is_admin,
                :require_login,
                :require_admin,
                :should_registration_active,
                :should_food_active,
                :should_allocation_active,
                :should_transport_active,
                :person_edit_redirect,
                :person_services_redirect

  before_filter :configure_actionmailer

  def set_active(action)
    if action_name == action
      #if request.original_url == link
      'class=active'
    end
  end

  def is_session_active
    !session[:user_id].nil?
  end

  def session_id
    # CAUTION! this function redirects, but you need to handle where you call it to stop.
    if is_session_active
      session[:user_id]
    else
      flash[:notice] = 'La sesión ha caducado'
      redirect_to login_url
      'redirected'
    end
  end

  def get_start
    if is_session_active
      url_for view_person_url
    else
      url_for root_url
    end
  end

  def is_admin
    session[:is_admin]
  end

  def require_login
    unless is_session_active
      flash[:error] = 'Tienes que tener una sesión activa para acceder la sección que solicitaste.'
      redirect_to login_url
    end
  end

  def require_admin
    unless is_session_active
      require_login
      return false
    end
    unless is_admin
      flash[:error] = 'Tienes que ser administrador para acceder la sección que solicitaste.'
      redirect_to root_url
      return false
    end
    true
  end

  def should_registration_active
    messages = []
    is_in_time = Time.now < Rails.application.config.reg_registration_deadline ? true : false
    unless is_in_time
      time_str = Rails.application.config.reg_food_deadline.strftime '%d/%m/%Y %H:%M %z'
      messages.append "El tiempo límite para registrarse era hasta antes del día #{time_str}"
    end
    is_allowed = is_in_time
    return is_allowed, messages
  end

  def should_food_active
    messages = []
    is_in_time = Time.now < Rails.application.config.reg_food_deadline ? true : false
    unless is_in_time
      time_str = Rails.application.config.reg_food_deadline.strftime '%d/%m/%Y %H:%M %z'
      messages.append "El tiempo límite era hasta el día #{time_str}"
    end
    is_allowed = is_in_time
    return is_allowed, messages
  end

  def should_allocation_active
    messages = []
    is_in_time = Time.now < Rails.application.config.reg_allocation_deadline ? true : false
    unless is_in_time
      time_str = Rails.application.config.reg_allocation_deadline.strftime '%d/%m/%Y %H:%M %z'
      messages.append "El tiempo límite era hasta el día #{time_str}"
    end
    is_allowed = is_in_time
    return is_allowed, messages
  end

  def should_transport_active
    messages = []
    return true, messages
  end

  def person_edit_redirect(person)
    # Checks if has admin_filters to change default redirection
    if session[:admin_filters] and (person.id != session_id)
      filters = session[:admin_filters]
      redirect_to people_path(filters),
                  notice: "#{person.full_name} (#{person.id}) fue actualizado con éxito."
    else
      # Normal user redirection
      redirect_to view_person_url,
                  notice: 'Registro actualizado con éxito.'
    end
  end

  def person_services_redirect(person_id, service_name, action)
    # Checks if has admin_filters to change default redirection
    if session[:admin_filters] and (person_id != session_id)
      filters = session[:admin_filters]
      redirect_to people_path(filters),
                  notice: "#{service_name} fue #{action} con éxito."
    else
      redirect_to view_person_url, notice: "#{service_name} #{action} con éxito."
    end
  end

  private
    def configure_actionmailer
      ActionMailer::Base.default_url_options[:protocol] = request.protocol
      ActionMailer::Base.default_url_options[:host] = request.host_with_port
    end
end
