# frozen_string_literal: true

class CartItemSerializer < ApplicationSerializer
  attributes :id, :quantity, :subtotal
  has_one :food_item
end
