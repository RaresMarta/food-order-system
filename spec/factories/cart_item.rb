FactoryBot.define do
  factory :cart_item do
    association :user
    association :food_item
    quantity { Faker::Number.between(from: 1, to: 5) }
  end
end
