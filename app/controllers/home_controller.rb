class HomeController < ApplicationController
    def index
      @food_items = FoodItem.all
    end
  end
