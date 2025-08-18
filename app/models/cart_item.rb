class CartItem < ApplicationRecord
  belongs_to :user
  belongs_to :food_item

  validates :quantity, numericality: { greater_than: 0, only_integer: true }
  validates :user_id, uniqueness: { scope: :food_item_id, message: "can only have one cart item per food item" }

  def subtotal
    food_item.price * quantity
  end
end
