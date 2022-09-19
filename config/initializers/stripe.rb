stripe_env = Rails.env.production? ? :production : :test
Stripe.api_key = Rails.application.credentials.dig(:stripe, stripe_env, :api_key)
