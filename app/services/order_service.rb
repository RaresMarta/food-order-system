# app/services/order_service.rb
class OrderService
  def initialize(order = nil)
    @order = order
  end

  def self.checkout(user, payment_method:)
    new.checkout(user, payment_method: payment_method)
  end

  def checkout(user, payment_method:)
    cart_items = user.cart_items.includes(:food_item)
    return { success: false, message: "Cart is empty" } if cart_items.blank?

    order = nil
    Order.transaction do
      order = create_order(user, payment_method, cart_items)  # <-- computes total here
      add_order_items(order, cart_items)
      clear_cart(cart_items)
    end

    { success: true, message: "Order placed successfully!", order: order }
  rescue => e
    { success: false, message: "Checkout failed: #{e.message}" }
  end

  def update_status(new_status, current_user)
    return { success: false, message: "Order not found" } unless @order
    return { success: false, message: "You are not authorized to update this order." } unless can_update_status?(new_status, current_user)

    if @order.update(status: new_status)
      { success: true, message: "Order ##{@order.id} status updated to #{new_status.humanize}!" , order: @order }
    else
      error_message = @order.errors.full_messages.join(", ").presence || "Invalid status provided"
      { success: false, message: "Failed to update order status: #{error_message}" }
    end
  end

  private

  def create_order(user, payment_method, cart_items)
    total = cart_items.sum do |ci|
      qty   = ci.quantity.to_i
      price = ci.food_item&.price || 0
      qty * price
    end

    user.orders.create!(
      status: :placed,
      payment_method: payment_method,
      total_price: total
    )
  end

  def add_order_items(order, cart_items)
    cart_items.each do |ci|
      order.order_items.create!(
        food_item:  ci.food_item,
        quantity:   ci.quantity,
        unit_price: ci.food_item.price
      )
    end
  end

  def clear_cart(cart_items)
    cart_items.delete_all
  end

  def can_update_status?(new_status, current_user)
    (new_status == "canceled" && @order.user == current_user) || current_user.admin?
  end
end
