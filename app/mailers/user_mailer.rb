# frozen_string_literal: true

# http://guides.rubyonrails.org/action_mailer_basics.html
class UserMailer < ApplicationMailer
  def welcome(user)
    prepare_email user
    mail to: @data.email_with_name,
         subject: "#{@data.author} - Bienvenido a la #{@data.event_title}"
  end

  def reset_password(user)
    prepare_email user
    mail to: @data.email_with_name,
         subject: "#{@data.author} - Restablecer contraseña"
  end

  def cancel(user)
    prepare_email user
    mail to: @data.email_with_name,
         subject: "#{@data.author} - Importante información sobre tu asistencia"
  end

  private

  def prepare_email(user)
    data = {
      author: Rails.configuration.app[:author],
      site_url: Rails.configuration.app[:site_url],
      event_name: Event.current.name,
      event_title: Event.current.event_title,
      user_id: user.id,
      user_name: user.name,
      user_email: user.email,
      user_rst: user.password_reset_token,
      user_rst_url: access_reset_url(user.password_reset_token),
      email_with_name: %("#{user.full_name}" <#{user.email}>)
    }
    @data = JSON.parse(data.to_json, object_class: OpenStruct)

    path = Rails.root.join('app', 'assets', 'images', 'email_logo.jpg')
    attachments.inline['logo.jpg'] = File.read(path)
  end
end
