class FoodItemsController < ApplicationController
  skip_before_action :require_login
  before_action :set_food_item, only: [ :update, :destroy ]
  before_action :initialize_food_item_service, only: [ :create, :update, :destroy ]

  def index
    @food_items = FoodItemQuery.new(params: params).call
  end

  def create
    result = @food_item_service.create_item(food_item_params)

    if result[:success]
      handle_result(result, dashboard_menu_path)
    else
      @food_item = result[:food_item]
      @food_items = FoodItem.all
      render "dashboard/menu", status: :unprocessable_entity
    end
  end

  def update
    if params[:reactivate]
      @food_item = FoodItem.unscoped.find(params[:id])
      if @food_item.update(deleted_at: nil)
        redirect_to dashboard_menu_path, notice: "#{@food_item.name} has been reactivated!"
      else
        redirect_to dashboard_menu_path, alert: "Failed to reactivate item."
      end
      return
    end

    result = @food_item_service.update_item(@food_item, food_item_params)

    if result[:success]
      handle_result(result, dashboard_menu_path)
    else
      @food_item = result[:food_item]
      @food_items = FoodItem.all
      render "dashboard/menu", status: :unprocessable_entity
    end
  end

  def destroy
    result = @food_item_service.delete_item(@food_item)
    handle_result(result, dashboard_menu_path)
  end

  private

  def initialize_food_item_service
    @food_item_service = FoodItemService.new
  end

  def set_food_item
    @food_item = FoodItem.find(params[:id])
  end

  def food_item_params
    params.require(:food_item).permit(:name, :category, :price, :vegetarian, :image)
  end
end
