class OrderSerializer < ApplicationSerializer
  attributes :id, :status, :created_at, :updated_at

  one :user, serializer: UserSerializer do |order|
    {
      id: order.user.id,
      name: order.user.name,
      email: order.user.email
    }
  end

  many :order_items, serializer: OrderItemSerializer

  attribute :total_amount do |order|
    (order.total_price || order.calculate_total).to_f
  end

  attribute :items_count do |order|
    order.order_items.size
  end
end
