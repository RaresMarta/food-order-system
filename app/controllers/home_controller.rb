class HomeController < ApplicationController
  def index
    @food_items = FoodItem.filtered(params)
  end
end
