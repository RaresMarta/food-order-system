class CartItemsController < ApplicationController
  before_action :require_login

  def create
    @food_item = FoodItem.find(params[:food_item_id])
    @cart_item = current_user.cart_items.find_by(food_item: @food_item)

    if @cart_item
      @cart_item.quantity += 1
      @cart_item.save
    else
      @cart_item = current_user.cart_items.create(food_item: @food_item, quantity: 1)
    end

    if @cart_item.persisted?
      flash[:notice] = "#{@food_item.name} added to cart!"
    else
      flash[:alert] = "Failed to add item to cart."
    end

    redirect_back fallback_location: root_path
  end

  def update
    @cart_item = current_user.cart_items.find(params[:id])

    if @cart_item.update(cart_item_params)
      flash[:notice] = "Cart updated successfully!"
    else
      flash[:alert] = "Failed to update cart."
    end

    redirect_to cart_path
  end

  def destroy
    @cart_item = current_user.cart_items.find(params[:id])
    @cart_item.destroy
    flash[:notice] = "Item removed from cart."
    redirect_to cart_path
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end
end
