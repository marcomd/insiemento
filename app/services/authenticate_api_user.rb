class AuthenticateApiUser
  prepend SimpleCommand

  attr_accessor :email, :password, :request

  def initialize(email, password, request=nil)
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
      user = User.find_by(email: email)
      if user && user.valid_password?(password)
        if user.confirmed_at.nil?
          errors.add :user_authentication, I18n.t('ui.users.alerts.unconfirmed')
          nil
        else
          user.update_tracked_fields! request if request
          user
        end
      else
        errors.add :user_authentication, I18n.t('ui.users.alerts.sign_up_error')
        nil
      end
    end

  end
end
