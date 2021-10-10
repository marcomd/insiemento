FactoryBot.define do
  factory :room do
    organization
    sequence(:name) { |n| "Room#{n}" }
    sequence(:description) { |n| "Description room #{n}" }
    max_attendees { 24 }
  end
end