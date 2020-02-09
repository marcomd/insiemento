class DeviseSendgridMailer < Devise::Mailer
  include ApplicationHelper
  include Devise::Controllers::UrlHelpers
  include Rails.application.routes.url_helpers

  def confirmation_instructions(record, token, opts={})
    link_url = api_ui_v1_user_confirmation_url(confirmation_token: token)
    SendgridMailer.account_confirmation(record, link_url: link_url).deliver
  end

  def reset_password_instructions(record, token, opts={})
    link_url = edit_api_ui_v1_user_password_url(reset_password_token: token)
    SendgridMailer.reset_password(record, link_url: link_url).deliver
  end

end
