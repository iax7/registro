class PersonMailer < ApplicationMailer

  def welcome(person)
    prepare_email person
    mail to: @email_with_name,
         subject: 'Bienvenido a la Segunda Conferencia Anual'
  end

  def reset(person)
    prepare_email person
    mail to: @email_with_name,
         subject: 'Restablecer contraseña'
  end

  def cancel(person)
    prepare_email person
    mail to: @email_with_name,
         subject: 'Importante! información sobre tu asistencia'
  end

  private
  def prepare_email(person)
    @person = person
    @email_with_name = %("#{person.name}" <#{person.email}>)
    @root = 'http://registro.cristianismobiblico.com/' #url_for root_url

    path = Rails.root.join('app', 'assets', 'images', 'cb.jpg')
    attachments.inline['cb.jpg'] = File.read(path)
  end

end
