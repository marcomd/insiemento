class JsonWebToken
  class << self
    ENCRYPTION_KEY = Rails.application.credentials.dig(:secret_key_base)

    def encode(payload, expiration_hours: CONFIG.dig(:authentication, :customer, :jwt_expiration_hours), digest: ENCRYPTION_KEY)
      payload[:exp] = expiration_hours.to_i.hours.from_now.to_i
      JWT.encode(payload, digest)
    end

    def decode(token, digest: ENCRYPTION_KEY)
      body = JWT.decode(token, digest)[0]
      ActiveSupport::HashWithIndifferentAccess.new(body)
    rescue StandardError
      nil
    end
  end
end
