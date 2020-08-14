FactoryBot.define do
  factory :course_event do
    organization
    category { build(:category, organization: organization) }
    course { build(:course, organization: organization, category: category) }
    room
    trainer
    course_schedule
    event_date { Time.zone.now }
  end
end