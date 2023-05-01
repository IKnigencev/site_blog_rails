FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "kldsajflkd43572lsWW" }
  end
end
