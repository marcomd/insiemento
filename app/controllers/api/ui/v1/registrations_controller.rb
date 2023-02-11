class Api::Ui::V1::RegistrationsController < Devise::RegistrationsController
  # include JwtAuthenticable
  before_action :check_and_sanitize_email_confirmation, only: [:create]
  skip_before_action :authenticate_request
  # protect_from_forgery with: :null_session

  respond_to :json

  def create
    user_attributes = user_params.to_h
    user_attributes[:email] = user_attributes[:email].downcase
    user_attributes[:organization_id] = @current_organization&.id
    # unless user_attributes[:organization_id]
    #   @current_organization = Organization.find_by(uuid: user_attributes[:organization_uuid]) if user_attributes[:organization_uuid]
    #   user_attributes[:organization_id] = @current_organization&.id
    # end
    @user = User.new(user_attributes.except(:email_confirmation))
    if @user.save
      render(:create, status: :created)
    else
      warden.custom_failure!
      render(json: { errors: @user.errors }, status: :unprocessable_entity)
    end
  end

  # For the destroy see the custom method API::Ui::V1::AuthenticationController#unregister

  private

  def user_params
    params.require(:user).permit(:email, :email_confirmation, :password, :password_confirmation,
                                 :firstname, :lastname, :phone, :birthdate, :gender,
                                 :child_firstname, :child_lastname, :child_birthdate, :format)
  end

  def check_and_sanitize_email_confirmation
    errors = get_errors
    render(json: { success: false, errors: }, status: :unprocessable_entity) and return if errors.present?
  end

  def get_errors
    errors = {}
    errors[:email] = ['is blank'] if user_params[:email].blank?
    errors[:email_confirmation] = ['is blank'] if user_params[:email_confirmation].blank?
    errors[:email] = ['does not coincide with email_confirmation'] if errors.blank? && user_params[:email] != user_params[:email_confirmation]
    errors
  end
end
