class DashboardController < ApplicationController
  def index
    @food_items = FoodItem.all.order(:id)
  end
end
