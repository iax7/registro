class PersonMailer < ApplicationMailer

  def welcome(person)
    prepare_email person
    mail to: @email_with_name,
         subject: "Cristianismo Bíblico - Bienvenido a la #{Rails.application.config.reg_event_name}"
  end

  def reset(person)
    prepare_email person
    mail to: @email_with_name,
         subject: 'Cristianismo Bíblico - Restablecer contraseña'
  end

  def cancel(person)
    prepare_email person
    mail to: @email_with_name,
         subject: 'Cristianismo Bíblico - Importante! información sobre tu asistencia'
  end

  private
  def prepare_email(person)
    @person = person
    @email_with_name = %("#{person.name}" <#{person.email}>)
    @root = 'http://registro.cristianismobiblico.com/' #url_for root_url

    path = Rails.root.join('app', 'assets', 'images', 'email_logo.jpg')
    attachments.inline['logo.jpg'] = File.read(path)
  end

end
