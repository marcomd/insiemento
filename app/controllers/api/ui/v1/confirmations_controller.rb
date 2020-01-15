class API::Ui::V1::ConfirmationsController < Devise::ConfirmationsController
  include GuestControllable
  protect_from_forgery with: :null_session
  respond_to :json

  include ApplicationHelper

  def create
    organization = Organization.find_by_subdomain(parsed_subdomain_without_locale)
    organization_id = organization.present? ? organization.id : resource_params[:organization_id]
    resource = Customer.find_for_database_authentication(email: resource_params[:email],
                                                         organization_id: organization_id)
    if resource.nil?
      render json: { success: false, email: resource_params[:email], errors: {email: [I18n.t('errors.messages.not_found')]} }, status: :unprocessable_entity
      return
    elsif resource.confirmed_at.present?
      render json: { success: false, email: resource_params[:email], errors: {email: [I18n.t('errors.messages.already_confirmed')]} }, status: :unprocessable_entity
      return
    end

    resource.send_confirmation_instructions
    if successfully_sent?(resource)
      render json: { success: true, email: resource.email }, status: :created
    else
      render json: { success: false, email: resource.email }, status: :unprocessable_entity
    end
  end

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    subdomain = build_partner_domain(resource&.organization&.subdomain, AppConfig.www_domain)
    if resource.errors.empty?
      redirect_to "#{subdomain}#{guests_path}/login?confirmed=true"
    else
      redirect_to "#{subdomain}#{guests_path}/confirmation-email?confirmed=false"
    end
  end

private

  def resource_params
    if params[:customer].present?
      params[:customer][:organization_id] ||= current_organization.id
      params.require(:customer).permit(:email, :auth_token, :organization_id)
    else
      {}
    end
  end

end
