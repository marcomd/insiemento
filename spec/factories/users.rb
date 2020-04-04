FactoryBot.define do
  factory :user do
    organization
    sequence(:email) { |n| "user#{n}@email.com" }
    sequence(:firstname) { |n| "John#{n}" }
    sequence(:lastname) { |n| "Smith#{n}" }
    sequence(:gender) { |n| n%2 == 0 ? 'M' : 'F' }
    password { 'heicwhihc1234' }
    password_confirmation { 'heicwhihc1234' }
    phone { '3331122333' }
    birthdate { Date.parse('1980-01-01') }
  end
end