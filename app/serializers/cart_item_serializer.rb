# frozen_string_literal: true

class CartItemSerializer < ApplicationSerializer
  attributes :id, :quantity

  attribute :subtotal do
    (object.quantity * object.food_item.price).to_f
  end

  has_one :food_item
end
