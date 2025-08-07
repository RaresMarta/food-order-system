class CartItemsController < ApplicationController
  skip_before_action :require_login
  before_action :set_cart_item, only: [ :update, :destroy ]

  def index
    @cart_items = current_user.cart_items.includes(:food_item)
    @total = @cart_items.sum { |item| item.food_item.price * item.quantity }
  end

  def create
    @food_item = FoodItem.find_by(id: params[:food_item_id])
    return redirect_back(fallback_location: root_path), flash: { alert: "Not found" } unless @food_item

    @cart_item = current_user.cart_items.find_or_initialize_by(food_item: @food_item)
    @cart_item.quantity = (@cart_item.quantity || 0) + 1
    @cart_item.save

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.turbo_stream
    end
  end

  def update
    if @cart_item.update(cart_item_params)
      flash[:notice] = "Cart updated successfully!"
    else
      flash[:alert] = "Failed to update cart."
    end

    redirect_to cart_path
  end

  def destroy
    @cart_item.destroy
    flash[:notice] = "Item removed from cart."
    redirect_to cart_path
  end

  private

  def set_cart_item
    @cart_item = current_user.cart_items.find(params[:id])
  end

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end
end
