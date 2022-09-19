FactoryBot.define do
  factory :course do
    organization
    category { build(:category, organization: organization) }
    course { build(:course, organization: organization, category: category) }
    sequence(:name) { |n| "Course#{n}" }
    sequence(:description) { |n| "Description#{n}" }
    start_booking_hours { 24 }
    end_booking_minutes { 60 }
    state { 'active' }
  end
end
