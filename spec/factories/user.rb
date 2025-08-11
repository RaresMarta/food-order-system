FactoryBot.define do
  factory :user do
    email { "john@email.com" }
    name { 'John' }
    password { "johnpassword" }
  end
end
