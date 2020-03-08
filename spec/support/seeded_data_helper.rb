module SeededDataHelper
  def user_stefania
    User.find(1)
  end

  def user_elena
    User.find_by_email('elena@fitness.io')
  end

  def stefania_subscribed_course_event_id
    1
  end

  def stefania_unsubscribed_course_event_id
    6
  end

  def stefania_unsubscribed_course_event
    CourseEvent.find stefania_unsubscribed_course_event_id
  end

  def authenticated_user(email)
    service = AuthenticateApiUser.call(email, Rails.application.credentials.seed.dig(:default_password))

    if service.success?
      service.result
    end
  end
end
