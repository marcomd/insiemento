# https://github.com/anusharanganathan/data2paper/wiki/Dual-authentication-using-Devise-and-JWT
class API::Ui::V1::AuthenticationController < API::Ui::BaseController
  skip_before_action :authenticate_request, only: [:authenticate]

  def authenticate
    require_relative Rails.root.join 'app/services/user_authentication/authenticate_user.rb'
    service = AuthenticateUser.call(params[:email],
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
