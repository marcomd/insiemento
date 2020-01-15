class API::Ui::V1::RegistrationsController < Devise::RegistrationsController
  include JWTAuthenticable
  include GuestControllable
  before_action :check_and_sanitize_email_confirmation, only: [:create]
  #before_action :authenticate_request, if: :json_request, only: [:destroy]

  protect_from_forgery with: :null_session

  respond_to :json

  def create
    customer = Customer.new(customer_params.except(:email_confirmation))
    customer.organization_id = current_organization.id
    customer.origin = Customer::ORIGIN_WEB
    result = begin
      Customer.transaction do
        if customer.save
          require_relative Rails.root.join 'app/services/guest_authentication/authenticate_customer.rb'
          service = AuthenticateUser.call(customer_params[:email],
                                          customer_params[:password],
                                          customer.organization_id)
          @auth_token = service.result
          @customer = service.customer
        end
        # Oltre a crearlo, dobbiamo verificare che si possa loggare
        raise 'Customer not authenticated' unless @customer
        true
      end
    rescue
      false
    end
    if result
      render :create, status: 201
    else
      warden.custom_failure!
      render json: { errors: customer.errors }, status: 422
    end
  end

  # For the destroy see the custom method API::Ui::V1::AuthenticationController#unregister

  private

  def customer_params
    if params[:customer].present?
      params.require(:customer).permit(:email, :email_confirmation, :password, :password_confirmation,
                                       :fiscal_code, :first_name, :last_name, :business_name,
                                       :document_number, :customer_type, :language, :category, :phone_prefix, :phone,
                                       :address, :cap,
                                       :birthdate, :sex, :identification_document_id, :document_issued_on,
                                       :document_expiring_date, :place_of_birth_id, :country_of_birth_id,
                                       :document_issued_location_id, :citizenship_id, :country_of_residence_id,
                                       :city_of_residence_id, :ok_marketing, :pending_order_uuid)
    else
      {}
    end
  end

  def check_and_sanitize_email_confirmation
    errors = {}
    if customer_params[:email].blank?
      errors[:email] ||= []
      errors[:email] << 'is blank'
    end
    if customer_params[:email_confirmation].blank?
      errors[:email_confirmation] ||= []
      errors[:email_confirmation] << 'is blank'
    end
    if errors.blank? && customer_params[:email] != customer_params[:email_confirmation]
      errors[:email] ||= []
      errors[:email] << 'does not coincide with email_confirmation'
    end
    render(json: { success: false, errors: errors }, status: 422) and return if errors.present?
  end
end
