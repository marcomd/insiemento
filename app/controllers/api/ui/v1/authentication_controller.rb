# https://github.com/anusharanganathan/data2paper/wiki/Dual-authentication-using-Devise-and-JWT
class Api::Ui::V1::AuthenticationController < Api::Ui::BaseController
  skip_before_action :authenticate_request, only: [:authenticate], raise: false

  def authenticate
    require_relative Rails.root.join 'app/services/user_authentication/authenticate_api_user.rb'
    service = AuthenticateApiUser.call(params[:email],
                                       params[:password],
                                       request)
    if service.success?
      @auth_token = service.result
      @user = service.user
      if @user.confirmed_at.nil?
        render json: { error: t('ui.users.alerts.unconfirmed') }, status: :unauthorized
      else
        @user.log_devise_action('login success')
        render :authenticate
      end
    else
      render json: { error: t('ui.users.alerts.login_error') }, status: :unauthorized
    end
  end
end
