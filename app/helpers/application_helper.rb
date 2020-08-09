module ApplicationHelper
  def get_user_domain(user)
    hostname = Rails.application.default_url_options[:host]
    organization = user.organization
    domain = organization.domain
    return hostname unless domain.present?
    if domain.include?('.')
      domain
    else
      # Its a subdomain...
      [organization.domain, hostname.sub('www.', '')].join('.')
    end
  end
end
