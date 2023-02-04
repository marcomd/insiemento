class Api::Ui::V1::PasswordsController < Devise::PasswordsController
  # protect_from_forgery with: :null_session
  skip_before_action :authenticate_request
  respond_to :json

  # la password recovery usa l'action create per inviare una mail all'utente
  def create
    resource = User.find_for_database_authentication(email: resource_params[:email])
    if resource.nil?
      render(json: { success: false, email: resource_params[:email], errors: { email: [I18n.t('errors.messages.not_found')] } }, status: :unprocessable_entity)
      return
    end

    resource.send_reset_password_instructions
    if successfully_sent?(resource)
      render(json: { success: true, email: resource.email }, status: :created)
    else
      render(json: { success: false, email: resource.email }, status: :unprocessable_entity)
    end
  end

  def edit
    original_token = params[:reset_password_token]
    reset_password_token = Devise.token_generator.digest(self, :reset_password_token, original_token)
    recoverable = User.find_by(reset_password_token:))

    if recoverable.present?
      if recoverable.persisted? && recoverable.reset_password_period_valid?
        redirect_to("#{users_url}/new-password?reset_password_token=#{original_token}")
      else
        redirect_to("#{users_url}/password-reset?error=invalid_token")
      end
    else
      redirect_to("#{users_url}/password-reset?error=invalid_token")
    end
  end

  def update
    original_token = params[:user][:reset_password_token]
    reset_password_token = Devise.token_generator.digest(self, :reset_password_token, original_token)
    recoverable = User.find_by(reset_password_token:))
    recoverable.update_attribute(:password, params[:user][:password])
    render(:update)
  end

  private

  def resource_params
    params.require(:user).permit(:email, :password, :password_confirmation, :reset_password_token)
  end
end
