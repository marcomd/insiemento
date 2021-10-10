FactoryBot.define do
  factory :penalty do
    organization
    category
    course { nil }
    state { :active }
    days { 7 }
  end
end
