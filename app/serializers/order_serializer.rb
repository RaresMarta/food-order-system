class OrderSerializer < ApplicationSerializer
  attributes :id, :status, :items_count, :total_price, :created_at, :updated_at

  many :order_items
end
