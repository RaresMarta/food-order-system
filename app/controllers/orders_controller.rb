class OrdersController < ApplicationController
  helper OrdersHelper
  before_action :require_login

  def index
    @orders = current_user.orders.includes(order_items: :food_item).order(created_at: :desc)
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def create
    result = OrderService.checkout(current_user, payment_method: params[:payment_method])
    if result[:success]
      redirect_to orders_path, notice: result[:message]
    else
      redirect_to cart_path, alert: result[:message]
    end
  end

  def update
    @order = Order.find(params[:id])
    redirect_path = request.referer&.include?('dashboard') ? dashboard_orders_path : orders_path

    result = OrderService.new(@order).update_status(params[:status], current_user)
    handle_result(result, redirect_path)
  end
end
