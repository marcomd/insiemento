FactoryBot.define do
  factory :attendee do
    user
    course_event
    organization { user.organization }
    subscription { user.active_subscriptions.last }
    presence { false }
  end
end
