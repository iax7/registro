# frozen_string_literal: true

# Sets the mail 'From'
class ApplicationMailer < ActionMailer::Base
  default from: Rails.configuration.app[:mailer_from_addr]
  layout 'mailer'
end
