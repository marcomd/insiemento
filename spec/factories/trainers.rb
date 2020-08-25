FactoryBot.define do
  factory :trainer do
    organization
    sequence(:firstname) { |n| "First name #{n}" }
    sequence(:lastname) { |n| "Last name #{n}" }
    sequence(:nickname) { |n| "Nickname #{n}" }
    sequence(:bio) { |n| "Bio #{n}" }
  end
end