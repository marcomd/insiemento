class ApplicationMailer < ActionMailer::Base
  default from: "please-do-not-reply@#{CONFIG.dig(:application, :host)}"
  layout 'mailer'
end
