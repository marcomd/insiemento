class AuthenticateUser
  prepend SimpleCommand

  attr_accessor :email, :password, :organization_id, :request

  def initialize(email, password, request=nil)
    require_relative Rails.root.join 'lib/fg/json_web_token.rb'
    @email = email
    @password = password
    @request = request
  end

  def call
    return if user.nil?
    JsonWebToken.encode(user_id: user.id)
  end

  def user
    @user ||= begin
      # Come opzione meno restrittiva si potrebbe eliminare il filtro organization per ottenere il primo user inserito
      user = User.find_by(email: email)
      if user && user.valid_password?(password)
        user.update_tracked_fields! request if request
        @user = user
      else
        errors.add :user_authentication, I18n.t('ui.users.alerts.sign_up_error')
        nil
      end
    end

  end
end
