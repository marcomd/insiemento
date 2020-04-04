FactoryBot.define do
  factory :organization do
    sequence(:name) { |n| "Organization#{n}" }
    sequence(:payoff) { |n| "Payoff #{n}" }
    sequence(:email) { |n| "email#{n}@test.org" }
    phone { '+393334455666' }
    sequence(:domain) { |n| "domain#{n}.com" }
  end
end