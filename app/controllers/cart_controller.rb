class CartController < ApplicationController
  before_action :require_login

  def show
    @cart_items = current_user.cart_items.includes(:food_item)
    @total = @cart_items.sum { |item| item.food_item.price * item.quantity }
  end
end
