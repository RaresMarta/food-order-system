class DashboardController < ApplicationController
  before_action :require_login

  def index
    @food_items = FoodItem.all.order(:id)
  end
end
