class OrderItemSerializer < ApplicationSerializer
  attributes :id, :quantity

  attribute :unit_price do |oi|
    oi.unit_price.to_f
  end

  attribute :subtotal do |oi|
    oi.subtotal.to_f
  end

  has_one :food_item
end
