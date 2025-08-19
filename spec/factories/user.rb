FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    name { Faker::Name.name }
    password { Faker::Internet.password(min_length: 6) }
  end
end
