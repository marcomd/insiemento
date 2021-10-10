FactoryBot.define do
  factory :user_penalty do
    user
    organization { user.organization }
    subscription { user.subscriptions.last }
    attendee { user.attendees.last }
    course_event { attendee.course_event }
    category { course_event.category }
    course { course_event.course }
    inhibited_until { Time.zone.today }
  end
end
