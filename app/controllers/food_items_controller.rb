class FoodItemsController < ApplicationController
  before_action :set_food_item, only: [ :update, :destroy ]

  # POST /food_items
  def create
    @food_item = FoodItem.new(food_item_params)

    if @food_item.save
      redirect_to dashboard_path, notice: "Food item created successfully!"
    else
      @food_items = FoodItem.all
      render "dashboard/index", status: :unprocessable_entity
    end
  end

  # PATCH /food_items/:id
  def update
    if @food_item.update(food_item_params)
      redirect_to dashboard_path, notice: "Food item updated successfully!"
    else
      @food_items = FoodItem.all
      render "dashboard/index", status: :unprocessable_entity
    end
  end

  # DELETE /food_items/:id
  def destroy
    @food_item.destroy
    redirect_to dashboard_path, notice: "Food item deleted successfully!"
  end

  private

  def set_food_item
    @food_item = FoodItem.find(params[:id])
  end

  def food_item_params
    params.require(:food_item).permit(:name, :category, :price, :vegetarian, :image)
  end
end
