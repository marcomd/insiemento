class DeviseMailer < Devise::Mailer
  # helper :application # gives access to all helpers defined within `application_helper`.
  include ApplicationHelper
  helper EmailHelper

  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  layout 'mailer'

  def confirmation_instructions(record, token, opts = {})
    @organization = record.organization
    @hostname = get_organization_domain(record.organization)
    super(record, token, opts)
  end

  def reset_password_instructions(record, token, opts = {})
    @organization = record.organization
    @hostname = get_organization_domain(record.organization)
    super(record, token, opts)
  end
end
