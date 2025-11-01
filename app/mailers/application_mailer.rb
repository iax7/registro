class ApplicationMailer < ActionMailer::Base
  default from: Rails.configuration.mailer_from_addr
  layout "mailer"
end
