FactoryBot.define do
  factory :order do
    organization
    user { build(:user, organization:) }
    sequence(:total_amount_cents, 10_000) { |n| (n + 1) * 100 }
    start_on { Time.zone.today }
  end
end
