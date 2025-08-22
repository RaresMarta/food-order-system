class OrderAdminSerializer < ApplicationSerializer
  attributes :id, :status, :items_count, :total_price, :created_at, :updated_at

  one :user

  many :order_items
end
