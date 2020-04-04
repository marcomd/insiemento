FactoryBot.define do
  factory :order do
    organization
    user { build(:user, organization: organization) }
    sequence(:total_amount_cents, 10000) { |n| (n+1) * 100 }
  end
end