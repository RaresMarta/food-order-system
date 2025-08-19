FactoryBot.define do
  factory :order_item do
    association :order
    association :food_item
    quantity { Faker::Number.between(from: 1, to: 5) }
    unit_price { food_item.price }
  end
end
