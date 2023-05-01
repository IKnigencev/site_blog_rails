FactoryBot.define do
  factory :comment do
    post { create(:post) }
    user { create(:user) }
    text { Faker::String.random(length: 100).tr("\u0000", "") }
  end
end
