FactoryBot.define do
  factory :room do
    organization
    sequence(:name) { |n| "Room#{n}" }
    max_attendees { 24 }
  end
end