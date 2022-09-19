FactoryBot.define do
  factory :news do
    organization
    title { 'MyTitle' }
    body { 'MyBody' }
  end
end
