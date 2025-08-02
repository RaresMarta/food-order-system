FactoryBot.define do
  factory :food_item do
    name { "Sample Food" }
    category { "Pizza" }
    price { 9.99 }
    vegetarian { false }
  end
end
