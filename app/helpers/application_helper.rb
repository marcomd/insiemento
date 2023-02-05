module ApplicationHelper
  def get_organization_domain(organization)
    hostname = Rails.application.default_url_options[:host]
    domain = organization.domain
    return hostname if domain.blank?

    if domain.include?('.')
      domain.include?('www.') ? domain : "www.#{domain}"
    else
      # Its a subdomain...
      [organization.domain, hostname.sub('www.', '')].join('.')
    end
  end

  def status_tag_for(object, field: :state)
    value = object.send(field)
    content_tag(:span, class: "status_tag #{value}") do
      I18n.t!("activerecord.attributes.#{object.class.name.underscore}.#{field}s.#{value}")
    end
  end
end
