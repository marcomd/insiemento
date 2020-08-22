FactoryBot.define do
  factory :product do
    organization
    category { build(:category, organization: organization) }
    sequence(:name) { |n| "Product#{n}" }
    description { 'Description' }
    sequence(:price_cents, 100) { |n| n * 100 }
    days { 30 }
    product_type { :fee }
  end
end