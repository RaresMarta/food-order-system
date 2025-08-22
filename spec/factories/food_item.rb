FactoryBot.define do
  factory :food_item do
    name { Faker::Food.dish }
    category { %w[default entrees main-courses second-courses salads pizza desserts].sample }
    price { Faker::Commerce.price(range: 5..100.0) }
    vegetarian { [ true, false ].sample }
  end
end
