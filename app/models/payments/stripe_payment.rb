class StripePayment < Payment
  # alias_method :external_code, :payment_intent_id
  # alias payment_intent_id external_code

  def confirmation_token
    @external_service_response ||= JSON.parse(external_service_response)
    @external_service_response['client_secret']
  end

  private

  def external_service_response_or_create
    external_service_response.present? ? external_service_response : create_intent
  end

  def create_intent
    intent = Stripe::PaymentIntent.create({
                                            amount: amount_cents,
                                            currency: 'eur',
                                            # Verify your integration in this guide by including this parameter
                                            metadata: { integration_check: 'payment' }
                                          })
    update_columns external_service_response: intent
    intent
  end
end
