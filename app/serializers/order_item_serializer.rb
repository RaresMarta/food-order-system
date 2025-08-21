class OrderItemSerializer < ApplicationSerializer
  attributes :id, :quantity

  attribute :unit_price do |oi|
    oi.unit_price.to_f
  end

  attribute :subtotal do |oi|
    oi.subtotal.to_f
  end

  attribute :food_item do |oi|
    fi = oi.food_item
    {
      id: fi.id,
      name: fi.name,
      price: fi.price.to_f
    }
  end
end
