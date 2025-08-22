class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  enum :status, { placed: 0, preparing: 1, ready: 2, delivered: 3, canceled: 4 }

  validates :total_price, presence: true, numericality: { greater_than: 0 }
  validates :payment_method, presence: true
  validates :status, presence: true

  scope :recent, -> { order(created_at: :desc) }

  def cancelable? = placed? || preparing?
  def items_count = order_items.size
end
