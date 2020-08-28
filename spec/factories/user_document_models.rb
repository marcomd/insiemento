FactoryBot.define do
  factory :user_document_model do
    organization { nil }
    state { :active }
    sequence(:title) { |n| "Title #{n}" }
    sequence(:body) { |n| "Body #{n}" }
    validity_days { 1 }
  end
end
