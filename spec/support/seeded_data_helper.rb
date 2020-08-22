module SeededDataHelper
  def user_stefania
    User.find(1)
  end

  def user_elena
    User.find_by_email('elena@fitness.io')
  end

  def user_paolo
    User.find_by_email('paolo@fitness.io')
  end

  def user_linda
    User.find_by_email('linda@fitness.io')
  end

  def stefania_subscribed_course_event_id
    1
  end

  def stefania_unsubscribed_course_event_id
    7
  end

  def paolo_unsubscribed_course_event_id
    2
  end

  def stefania_unsubscribed_course_event
    CourseEvent.find stefania_unsubscribed_course_event_id
  end

  def order_with_paid_payments
    Order.find(1)
  end

  def order_with_unconfirmed_payments
    Order.find(2)
  end

  def order_without_payments
    Order.find(3)
  end

  def stripe_payment_confirmed
    StripePayment.confirmed.first
  end

  def stripe_payment_unconfirmed
    StripePayment.just_made.first
  end

  def authenticated_user(email)
    service = AuthenticateApiUser.call(email, Rails.application.credentials.seed.dig(:default_password))

    if service.success?
      service.result
    end
  end
end
