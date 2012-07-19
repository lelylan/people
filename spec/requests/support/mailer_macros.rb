module MailerMacros
  def last_email
    ActionMailer::Base.deliveries.last
  end

  def reset_email
    ActionMailer::Base.deliveries = []
  end

  def reset_password_token(mail)
    body = mail.default_part_body.to_s
    uris = URI.extract body
    URI.parse(uris.last).query.split('=').last
  end
end

RSpec.configuration.include MailerMacros
