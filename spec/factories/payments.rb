FactoryBot.define do
  factory :payment do
    organization
    user { build(:user, organization:) }
    order { build(:order, user:, organization:) }
    source { 'frontend' }
    sequence(:amount_cents, 10_000) { |n| (n + 1) * 100 }
  end

  factory :stripe_payment, parent: :payment, class: 'StripePayment' do
    external_service_response do
      {
        id: 'pi_1GmIPWFBKMhSCxMuij0bwJMo',
        object: 'payment_intent',
        last_payment_error: nil,
        livemode: false,
        next_action: nil,
        status: 'requires_payment_method',
        amount: 34_800,
        amount_capturable: 0,
        amount_received: 0,
        application: nil,
        application_fee_amount: nil,
        canceled_at: nil,
        cancellation_reason: nil,
        capture_method: 'automatic',
        charges: {
          object: 'list',
          data: [],
          has_more: false,
          total_count: 0,
          url: '/v1/charges?payment_intent=pi_1GmIPWFBKMhSCxMuij0bwJMo',
        },
        client_secret: 'pi_1GmIPWFBKMhSCxMuij0bwJMo_secret_WjkzuGJuFtmioE1hzl0UXbv3v',
        confirmation_method: 'automatic',
        created: 1_590_321_274,
        currency: 'eur',
        customer: nil,
        description: nil,
        invoice: nil,
        metadata: {
          integration_check: 'accept_a_payment',
        },
        on_behalf_of: nil,
        payment_method: nil,
        payment_method_options: {
          card: {
            installments: nil,
            request_three_d_secure: 'automatic',
          },
        },
        payment_method_types: [
          'card',
        ],
        receipt_email: nil,
        review: nil,
        setup_future_usage: nil,
        shipping: nil,
        source: nil,
        statement_descriptor: nil,
        statement_descriptor_suffix: nil,
        transfer_data: nil,
        transfer_group: nil,
      }.to_json
    end
  end
end
