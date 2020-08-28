FactoryBot.define do
  factory :user_document do
    organization { nil }
    user_document_model { nil }
    user { nil }
    state { :new }
  end
end
