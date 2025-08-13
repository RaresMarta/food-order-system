class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  enum :status, { preparing: 0, ready: 1, delivered: 2, canceled: 3 }

  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :payment_method, presence: true
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }
  validates :user, presence: true
end
