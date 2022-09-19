class Api::Ui::V1::ConfirmationsController < Devise::ConfirmationsController
  # protect_from_forgery with: :null_session
  skip_before_action :authenticate_request
  respond_to :json

  def create
    resource = User.find_for_database_authentication(email: resource_params[:email])
    if resource.nil?
      render json: { success: false, email: resource_params[:email], errors: { email: [I18n.t('errors.messages.not_found')] } }, status: :unprocessable_entity
      return
    elsif resource.confirmed_at.present?
      render json: { success: false, email: resource_params[:email], errors: { email: [I18n.t('errors.messages.already_confirmed')] } }, status: :unprocessable_entity
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

    if resource.errors.empty?
      redirect_to "#{users_url}/login?confirmed=true"
    else
      redirect_to "#{users_url}/confirmation-email?confirmed=false"
    end
  end

  private

  def resource_params
    params.require(:user).permit(:email, :auth_token)
    # if params[:user].present?
    # else
    #   {}
    # end
  end
end
