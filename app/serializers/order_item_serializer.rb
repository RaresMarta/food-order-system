class OrderItemSerializer < ApplicationSerializer
  attributes :id, :quantity, :price

  one :food_item, serializer: FoodItemSerializer do |order_item|
    {
      id: order_item.food_item.id,
      name: order_item.food_item.name
    }
  end

  attribute :price do |order_item|
    order_item.price&.to_f || 0
  end
end
