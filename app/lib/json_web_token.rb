class JsonWebToken
  class << self
    ENCRYPTION_KEY = Rails.application.credentials.dig(:secret_key_base)

    def encode(payload, exp = CONFIG.dig(:authentication, :customer, :jwt_expiration_hours))
      payload[:exp] = exp.to_i.hours.from_now.to_i
      JWT.encode(payload, ENCRYPTION_KEY)
    end

    def decode(token)
      body = JWT.decode(token, ENCRYPTION_KEY)[0]
      HashWithIndifferentAccess.new body
    rescue
      nil
    end
  end
end
