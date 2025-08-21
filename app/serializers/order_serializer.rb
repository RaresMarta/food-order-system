class OrderSerializer < ApplicationSerializer
  attributes :id, :status, :created_at, :updated_at

  one :user, serializer: UserSerializer do |order|
    {
      id: order.user.id,
      email: order.user.email,
      total_orders: order.user.orders.count
    }
  end

  many :order_items, serializer: OrderItemSerializer

  attribute :total_amount do |order|
    order.total_price&.to_f || 0
  end

  attribute :items_count do |order|
    order.order_items.count
  end
end
