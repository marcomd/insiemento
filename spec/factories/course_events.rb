FactoryBot.define do
  factory :course_event do
    organization
    category { build(:category, organization: organization) }
    course { build(:course, organization: organization, category: category) }
    room { organization.rooms.first }
    trainer { organization.trainers.first }
    course_schedule { build(:course_schedule, organization: organization, category: category, course: course, room: room, trainer: trainer) }
    event_date { Time.zone.now }
  end
end
