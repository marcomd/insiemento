FactoryBot.define do
  factory :subscription do
    organization
    product
    user { nil }
    subscription_type { :fee }
    start_on { '2020-08-01' }
    state { :active }
    max_accesses_number { nil }
  end
end
