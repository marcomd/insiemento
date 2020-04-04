FactoryBot.define do
  factory :product do
    organization
    category
    sequence(:name) { |n| "Product#{n}" }
    description { 'Description' }
    sequence(:price_cents, 100) { |n| n * 100 }
    days {30}
  end
end