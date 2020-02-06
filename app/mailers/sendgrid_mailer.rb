#
# Sendgrid mailer wrapper
#
class SendgridMailer < ApplicationMailer

  def account_confirmation(user, link_url:, debug: false)
    language = 'it'
    json_data = {
        firstname: user.firstname,
        application_name: CONFIG.dig(:application, :commercial, :brand),
        link_url: link_url
    }

    template_id = get_remote_template_id(__method__)[language]

    SendgridService.call(:send_email, {from: { email: "please-do-not-replay@#{CONFIG.dig(:application, :host)}", name: CONFIG.dig(:application, :commercial, :brand) },
                                       to: user.email,
                                       reply_to: nil,
                                       template_id: template_id,
                                       dynamic_template_data: json_data,
                                       attachments: nil,
                                       debug: debug})

  end

  def reset_password(user, link_url:, debug: false)
    language = 'it'
    json_data = {
        firstname: user.firstname,
        application_name: CONFIG.dig(:application, :name),
        link_url: link_url
    }

    template_id = SendgridService.get_remote_template_id(__method__)[language]

    SendgridService.call(:send_email, {from: { email: 'please-do-not-replay@insiemento.io', name: 'Customer Service' },
                                       to: user.email,
                                       reply_to: nil,
                                       template_id: template_id,
                                       dynamic_template_data: json_data,
                                       attachments: nil,
                                       debug: debug})
  end

  private

  def get_remote_template_id(mailer)
    YAML.load(File.read("#{Rails.root}/config/sendgrid/templates.yml")).fetch(mailer.to_s)
  end

end
