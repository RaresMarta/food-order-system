class DashboardController < ApplicationController
  before_action :require_admin

  def index
    @food_items = FoodItem.all
    @food_item = params[:edit_id] ? FoodItem.find(params[:edit_id]) : nil
  end
end
