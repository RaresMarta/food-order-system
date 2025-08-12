class DashboardController < ApplicationController
  before_action :require_admin

  def index
    @food_items = FoodItem.all
    @food_item = params[:edit_id] ? FoodItem.find(params[:edit_id]) : nil
    @recent_orders = Order.includes(order_items: :food_item, user: :orders).order(created_at: :desc).limit(10)
    @orders_today = Order.where(created_at: Date.current.all_day).count
    @total_revenue_today = Order.where(created_at: Date.current.all_day).sum(:total_price)
  end
end
