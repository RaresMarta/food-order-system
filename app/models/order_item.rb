class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :food_item

  validates :food_item, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :order, presence: true
end
