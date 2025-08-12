class OrdersController < ApplicationController
  helper OrdersHelper
  before_action :require_login
  before_action :set_order, only: [ :show ]

  def index
    @orders = current_user.orders.includes(order_items: :food_item).order(created_at: :desc)
  end

  def show
    # Order details view
  end

  def create
    begin
      @order = CheckoutService.new(current_user, payment_method: params[:payment_method]).call
      redirect_to orders_path, notice: "Order placed successfully!"
    rescue => e
      redirect_to cart_path, alert: e.message
    end
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  end
end
