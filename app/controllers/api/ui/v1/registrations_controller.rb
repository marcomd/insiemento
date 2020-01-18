class Api::Ui::V1::RegistrationsController < Devise::RegistrationsController
  # include JWTAuthenticable
  before_action :check_and_sanitize_email_confirmation, only: [:create]

  # protect_from_forgery with: :null_session

  respond_to :json

  def create
    user = User.new(user_params.except(:email_confirmation))
    result = begin
      User.transaction do
        if user.save
          require_relative Rails.root.join 'app/services/user_authentication/authenticate_api_user.rb'
          service = AuthenticateApiUser.call(user_params[:email],
                                             user_params[:password],
                                             request)
          @auth_token = service.result
          @user = service.user
        end
        # Oltre a crearlo, dobbiamo verificare che si possa loggare
        raise 'User not authenticated' unless @user
        true
      end
    rescue
      false
    end
    if result
      render :create, status: 201
    else
      warden.custom_failure!
      render json: { errors: user.errors }, status: 422
    end
  end

  # For the destroy see the custom method API::Ui::V1::AuthenticationController#unregister

  private

  def user_params
    params.require(:user).permit(:email, :email_confirmation, :password, :password_confirmation,
                                 :firstname, :lastname, :phone, :birthdate, :gender, :format )
    # if params[:user].present?
    # else
    #   {}
    # end
  end

  def check_and_sanitize_email_confirmation
    errors = {}
    if user_params[:email].blank?
      errors[:email] ||= []
      errors[:email] << 'is blank'
    end
    if user_params[:email_confirmation].blank?
      errors[:email_confirmation] ||= []
      errors[:email_confirmation] << 'is blank'
    end
    if errors.blank? && user_params[:email] != user_params[:email_confirmation]
      errors[:email] ||= []
      errors[:email] << 'does not coincide with email_confirmation'
    end
    render(json: { success: false, errors: errors }, status: 422) and return if errors.present?
  end
end
