# frozen_string_literal: true

class CartItemSerializer < ApplicationSerializer
  attributes :id, :quantity

  attribute :subtotal do
    (object.quantity * object.food_item.price).to_f
  end

  attribute :food_item do |ci|
    fi = ci.food_item
    {
      id: fi.id,
      name: fi.name,
      price: fi.price,
      vegetarian: fi.vegetarian?
    }
  end
end
