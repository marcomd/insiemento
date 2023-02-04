FactoryBot.define do
  factory :course_event do
    organization
    category { build(:category, organization:) }
    course { build(:course, organization:, category:) }
    room { organization.rooms.first }
    trainer { organization.trainers.first }
    course_schedule { build(:course_schedule, organization:, category:, course:, room:, trainer:) }
    event_date { Time.zone.now }
  end
end
