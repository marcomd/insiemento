#
# Sendgrid mailer wrapper
#
class SendgridMailer < ApplicationMailer
  def account_confirmation(user, link_url:, debug: false)
    current_organization = user.organization
    language = 'it'
    json_data = {
      firstname: user.firstname,
      application_name: current_organization.name,
      link_url:,
    }

    template_id = get_remote_template_id(__method__)[language]

    SendgridService.call(:send_email,
                         current_organization,
                         {
                           from: { email: "please-do-not-reply@#{current_organization.domain}", name: current_organization.name },
                           to: user.email,
                           reply_to: nil,
                           template_id:,
                           dynamic_template_data: json_data,
                           attachments: nil,
                           debug:,
                         })
  end

  def reset_password(user, link_url:, debug: false)
    current_organization = user.organization
    language = 'it'
    json_data = {
      firstname: user.firstname,
      application_name: current_organization.name,
      link_url:,
    }

    template_id = get_remote_template_id(__method__)[language]

    SendgridService.call(:send_email,
                         current_organization,
                         {
                           from: { email: "please-do-not-reply@#{current_organization.domain}", name: current_organization.name },
                           to: user.email,
                           reply_to: nil,
                           template_id:,
                           dynamic_template_data: json_data,
                           attachments: nil,
                           debug:,
                         })
  end

  private

  def get_remote_template_id(mailer)
    YAML.load(Rails.root.join('config/sendgrid/templates.yml').read).fetch(mailer.to_s)
  end
end
