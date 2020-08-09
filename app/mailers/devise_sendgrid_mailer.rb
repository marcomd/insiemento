class DeviseSendgridMailer < Devise::Mailer
  include ApplicationHelper
  include Devise::Controllers::UrlHelpers
  include Rails.application.routes.url_helpers

  def confirmation_instructions(user, token, opts={})
    hostname = get_user_domain(user)
    link_url = api_ui_v1_user_confirmation_url(confirmation_token: token, host: hostname)
    SendgridMailer.account_confirmation(user, link_url: link_url).deliver
  end

  def reset_password_instructions(user, token, opts={})
    hostname = get_user_domain(user)
    link_url = edit_api_ui_v1_user_password_url(reset_password_token: token, host: hostname)
    SendgridMailer.reset_password(user, link_url: link_url).deliver
  end
end
