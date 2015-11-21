require 'icalendar'
include Icalendar

class WelcomeController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:login]

  def index
    @is_event_ended = is_event_finished
  end

  # GET/POST
  def login
    if request.post?
      params.permit(:email, :password)
      email = params[:email]
      password = params[:password]
      person = Person.find_by_email(email)
      if person.nil?
        flash[:error] = 'Usuario no encontrado'
      else
        if person.validate_password(password)
          #Checks if Event has ended
          if (is_event_finished) and (!person.isadmin)
            flash[:error] = 'La conferencia ha concluido.'
            redirect_to welcome_index_path
            return
          end

          session[:user_id] = person.id
          session[:is_admin] = person.isadmin?
          session[:user_name] = person.name
          flash[:error] = nil
          redirect_to person_path person.id
        else
          flash[:error] = 'Contraseña inválida'
        end
      end
    end
  end

  # GET
  def logout
    if is_session_active
      reset_session
      #session.delete :user_id
      redirect_to root_url
    end
  end

  # GET/POST reset/:id/:verify
  #  GET is Step 2, validates token and shows change password form
  # POST is Step 3, changes the password
  def reset
    if request.post?
      params.permit(:mail, :password)
      email = params[:mail]
      password = params[:password]
      p = Person.find_by_email(email)
      p.set_password password
      p.save
      flash[:notice] = 'La contraseña fue cambiada.'
      redirect_to root_url
    elsif request.get?
      begin
        url_id = Base64.urlsafe_decode64 params[:id]
        url_ver = Base64.urlsafe_decode64 params[:verify]
        p = Person.find(url_id)
        @email = p.email
        flash[:error] = 'Error en el url' if p.nil?

        valid = p.validate_reset_password_token(url_ver)
        flash[:error] = 'El token ha vencido, por favor genera uno nuevo.' if valid.nil?
        @is_valid = valid
      rescue #ActiveSupport::MessageVerifier::InvalidSignature
        flash[:error] = 'La firma es inválida'
        redirect_to root_url
      end
    end
  end

  # GET  recover
  # POST recover
  # POST Step 1, sends the token to email
  def recover
    if request.post?
      params.permit(:email)
      email = params[:email]
      p = Person.find_by_email(email)
      if p.nil?
        flash[:error] = 'Email no encontrado'
        return
      end
      PersonMailer.reset(p).deliver_now
      flash[:notice] = "Las instrucciones para restablecer la contraseña fueron enviadas a #{email}"
      redirect_to root_url
    end
  end

  # GET ICS
  def schedule
    # Testing this module
    event = Event.new
    event.dtstart = DateTime.new(2015, 11, 24, 17, 00, 00)
    event.dtend = DateTime.new(2015, 11, 24, 23, 00, 00)
    event.summary = 'Segunda Conferencia Anual 2015 - Cristianismo Bíblico'
    event.description = 'Primer día de las conferencias'
    event.location = "https://www.google.com.mx/maps/place/20%C2%B030'50.3%22N+103%C2%B025'36.1%22W/@20.5193828,-103.4157,14z/data=!4m2!3m1!1s0x842f53a1f3161963:0xfee4acbd2a5a215c"
    event.created = DateTime.now
    event.last_modified = DateTime.now
    event.uid = 'uid'
    #render :text => event.to_ical
    send_data event.to_ical,
              filename: "SegundaConferencia2015.ics",
              type: 'application/ics',
              disposition: 'attachment'
  end

  def adminhelp
    unless is_admin
      redirect_to action: :show
    end
  end

  private
  def is_event_finished
    event_ends_date = Rails.application.config.reg_event_ends
    Time.now > event_ends_date
  end
end
