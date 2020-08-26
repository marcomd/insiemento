module ApplicationHelper
  def get_organization_domain(organization)
    hostname = Rails.application.default_url_options[:host]
    domain = organization.domain
    return hostname unless domain.present?
    if domain.include?('.')
      domain.include?('www.') ? domain : "www.#{domain}"
    else
      # Its a subdomain...
      [organization.domain, hostname.sub('www.', '')].join('.')
    end
  end
end
