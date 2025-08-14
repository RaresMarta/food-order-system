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
    begin
      Order.transaction do
        order = create_order(user, payment_method)
        total = add_order_items(order, cart_items)
        order.update!(total_price: total)
        clear_cart(cart_items)
      end
      { success: true, message: "Order placed successfully!", order: order }
    rescue => e
      { success: false, message: "Checkout failed: #{e.message}" }
    end
  end

  def update_status(new_status, current_user)
    return { success: false, message: "Order not found" } unless @order
    return { success: false, message: "You are not authorized to update this order." } unless can_update_status?(new_status, current_user)

    if @order.update(status: new_status)
      { success: true, message: "Order ##{@order.id} status updated to #{new_status.humanize}!" }
    else
      error_message = @order.errors.full_messages.join(", ").presence || "Invalid status provided"
      { success: false, message: "Failed to update order status: #{error_message}" }
    end
  end

  private

  def create_order(user, payment_method)
    user.orders.create!(
      status: :preparing,
      payment_method: payment_method,
      total_price: 0
    )
  end

  def add_order_items(order, cart_items)
    total = 0
    cart_items.each do |ci|
      unit_price = ci.food_item.price
      order.order_items.create!(
        food_item: ci.food_item,
        quantity: ci.quantity,
        unit_price: unit_price
      )
      total += unit_price * ci.quantity
    end
    total
  end

  def clear_cart(cart_items)
    cart_items.delete_all
  end

  def can_update_status?(new_status, current_user)
    # Users can cancel their own orders
    return true if new_status == "canceled" && @order.user == current_user

    # Admins can update any status
    return true if current_user.admin?

    false
  end
end
