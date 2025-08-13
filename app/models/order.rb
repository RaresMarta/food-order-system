class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  enum :status, { preparing: 0, ready: 1, delivered: 2, canceled: 3 }
end
