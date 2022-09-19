FactoryBot.define do
  factory :category do
    organization
    sequence(:name) { |n| "Category#{n}" }
  end
end
