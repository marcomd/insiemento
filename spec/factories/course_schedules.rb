FactoryBot.define do
  factory :course_schedule do
    organization
    category { build(:category, organization: organization) }
    course { build(:course, organization: organization, category: category) }
    room
    trainer
    event_day { 1 }
    event_time { Time.zone.now }
  end
end