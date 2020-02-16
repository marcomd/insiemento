# https://github.com/anusharanganathan/data2paper/wiki/Dual-authentication-using-Devise-and-JWT
class Api::Ui::V1::AuthenticationController < Api::Ui::BaseController
  skip_before_action :authenticate_request, only: [:authenticate], raise: false

  def authenticate
    service = AuthenticateApiUser.call(login_params[:email].downcase,
                                       login_params[:password],
                                       request)
    if service.success?
      @auth_token = service.result
      @user = service.user
      if @user.confirmed_at.nil?
        render json: { error: t('ui.users.alerts.unconfirmed') }, status: :unauthorized
      else
        render :authenticate
      end
    else
      render json: { error: t('ui.users.alerts.login_error') }, status: :unauthorized
    end
  end

  private

  def login_params
    params.require(:authentication).permit(:email, :password, :rememberMe, :format )
  end
end
