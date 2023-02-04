FactoryBot.define do
  factory :course_schedule do
    organization
    category { build(:category, organization:) }
    course { build(:course, organization:, category:) }
    room { organization.rooms.first }
    trainer { organization.trainers.first }
    event_day { 1 }
    event_time { Time.zone.now }
  end
end
