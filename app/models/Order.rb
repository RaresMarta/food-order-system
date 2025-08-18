class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  enum :status, { placed: 0, preparing: 1, ready: 2, delivered: 3, canceled: 4 }
end
