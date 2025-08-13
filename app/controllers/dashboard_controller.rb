class DashboardController < ApplicationController
  before_action :require_admin
  layout 'dashboard_layout', only: [:orders, :menu]

  def index
    @orders_today = Order.where(created_at: Date.current.all_day).count
    @total_revenue_today = Order.where(created_at: Date.current.all_day).sum(:total_price)
    @total_food_items = FoodItem.active.count
    @total_orders = Order.count
  end

  def orders
    @all_orders = Order.includes(order_items: :food_item, user: :orders).order(created_at: :desc)
  end

  def menu
    @food_items = FoodItem.active
    @deleted_food_items = FoodItem.where.not(deleted_at: nil)
    @food_item = params[:edit_id] ? FoodItem.find(params[:edit_id]) : nil
  end
end
