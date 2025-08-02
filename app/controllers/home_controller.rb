class HomeController < ApplicationController
  def index
    @food_items = FoodItemQuery.new(params: params).call
  end
end
