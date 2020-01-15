class API::Ui::V1::PasswordsController < Devise::PasswordsController
  include GuestControllable
  protect_from_forgery with: :null_session
  respond_to :json

  include ApplicationHelper

  # la password recovery usa l'action create per inviare una mail all'utente
  def create
    organization = Organization.find_by_subdomain(parsed_subdomain_without_locale)
    organization_id = organization.present? ? organization.id : resource_params[:organization_id]
    resource = Customer.find_for_database_authentication(email: resource_params[:email],
                                                         organization_id: organization_id)
    if resource.nil?
      render json: { success: false, email: resource_params[:email], errors: {email: [I18n.t('errors.messages.not_found')]} }, status: :unprocessable_entity
      return
    end

    resource.send_reset_password_instructions
    if successfully_sent?(resource)
      render json: { success: true, email: resource.email }, status: :created
    else
      render json: { success: false, email: resource.email }, status: :unprocessable_entity
    end
  end

  def edit
    original_token = params[:reset_password_token]
    reset_password_token = Devise.token_generator.digest(self, :reset_password_token, original_token)
    recoverable = Customer.find_by reset_password_token: reset_password_token

    if recoverable.present?
      subdomain = build_partner_domain(recoverable.organization.subdomain, AppConfig.www_domain)
      if recoverable.persisted? && recoverable.reset_password_period_valid?
        redirect_to "#{subdomain}#{guests_path}/new-password?reset_password_token=#{original_token}"
      else
        redirect_to "#{subdomain}#{guests_path}/password-reset?error=invalid_token"
      end
    else
      subdomain = build_partner_domain(nil, AppConfig.www_domain)
      redirect_to "#{subdomain}#{guests_path}/password-reset?error=invalid_token"
    end
  end

  def update
    original_token = params[:customer][:reset_password_token]
    reset_password_token = Devise.token_generator.digest(self, :reset_password_token, original_token)
    recoverable = Customer.find_by reset_password_token: reset_password_token
    recoverable.update_attribute(:password, params[:customer][:password])
    render :update
  end

  private

  def resource_params
    params[:customer][:organization_id] ||= current_organization.id
    params.require(:customer).permit(:email, :password, :password_confirmation, :reset_password_token, :organization_id)
  end
end
