class CheckoutService
  def initialize(user, payment_method:)
    @user = user
    @payment_method = payment_method
  end

  def call
    cart_items = @user.cart_items.includes(:food_item)
    raise "Cart is empty" if cart_items.blank?

    Order.transaction do
      order = @user.orders.create!(
        status: :placed,
        payment_method: @payment_method,
        total_price: 0
      )
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

      order.update!(total_price: total)
      cart_items.delete_all
      order
    end
  end
end
