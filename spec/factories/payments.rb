FactoryBot.define do
  factory :payment do
    organization
    user { build(:user, organization: organization) }
    order { build(:order, user: user, organization: organization) }
    source { 'stripe' }
    sequence(:amount_cents, 10000) { |n| (n+1) * 100 }
  end
end