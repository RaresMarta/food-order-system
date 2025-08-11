FactoryBot.define do
  factory :cart_item do
    user { nil }
    food_item { nil }
    quantity { 1 }
  end
end
