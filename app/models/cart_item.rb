class CartItem < ApplicationRecord
  belongs_to :user
  belongs_to :food_item

  validates :quantity, numericality: { greater_than: 0 }
end
