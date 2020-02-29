class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  private

  def current_organization
    @current_organization ||= Organization.find(ENV['ORGANIZATION'])
  end
end
