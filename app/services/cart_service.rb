class CartService
  def initialize(user)
    @user = user
  end

  def add_item(food_item_id)
    food_item = FoodItem.find_by(id: food_item_id)
    return { success: false, message: "Food item not found" } unless food_item

    cart_item = @user.cart_items.find_or_initialize_by(food_item: food_item)
    cart_item.quantity = (cart_item.quantity || 0) + 1

    if cart_item.save
      { success: true, message: "Added to cart!", cart_item: cart_item }
    else
      { success: false, message: "Failed to add item to cart" }
    end
  end

  def update_item(cart_item, quantity)
    if cart_item.update(quantity: quantity)
      { success: true, message: "Cart updated!" }
    else
      { success: false, message: "Failed to update cart" }
    end
  end

  def remove_item(cart_item)
    if cart_item.destroy
      { success: true, message: "Item removed from cart" }
    else
      { success: false, message: "Failed to remove item" }
    end
  end

  def cart_total
    @user.cart_items.includes(:food_item).sum { |item| item.food_item.price * item.quantity }
  end
end
