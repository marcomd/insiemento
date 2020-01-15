module JWTAuthenticable
  extend ActiveSupport::Concern

  private

  def authenticate_request
    require_relative Rails.root.join "app/services/user_authentication/authorize_api_request.rb"
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end
end
