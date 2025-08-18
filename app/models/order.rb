class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  enum :status, { placed: 0, preparing: 1, ready: 2, delivered: 3, canceled: 4 }

  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :payment_method, presence: true
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }
  validates :user, presence: true
end
