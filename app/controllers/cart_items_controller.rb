class CartItemsController < ApplicationController
  before_action :set_cart_item, only: [ :update, :destroy ]
  before_action :initialize_cart_service

  def index
    @cart_items = current_user.cart_items.includes(:food_item)
    @total = @cart_service.cart_total
  end

  def create
    if params[:order_id].present?
      result = @cart_service.add_items_from_order(params[:order_id])
      handle_result(result, cart_path)
    else
      result = @cart_service.add_item(params[:food_item_id])
      handle_result(result, root_path, use_flash_now: true)
    end
  end

  def update
    result = @cart_service.update_item(@cart_item, cart_item_params[:quantity])
    handle_result(result, cart_path)
  end

  def destroy
    result = @cart_service.remove_item(@cart_item)
    handle_result(result, cart_path)
  end

  private

  def initialize_cart_service
    @cart_service = CartService.new(current_user)
  end

  def set_cart_item
    @cart_item = current_user.cart_items.find(params[:id])
  end

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end
end
