FactoryBot.define do
  factory :post do
    user { create(:user) }
    title { Faker::String.random(length: 100).tr("\u0000", "") }
    text { Faker::Lorem.paragraphs.join("<br />").tr("\u0000", "") }
  end
end
