class ApplicationMailer < ActionMailer::Base
  default from: "please-do-not-reply@#{CONFIG.dig(:application, :host)}"
  layout 'mailer'

  private

  def current_organization
    @current_organization ||= Organization.find(ENV['ORGANIZATION'])
  end
end
