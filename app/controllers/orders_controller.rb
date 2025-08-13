class OrdersController < ApplicationController
  helper OrdersHelper
  before_action :require_login
  before_action :require_admin, only: [:update]

  def index
    @orders = current_user.orders.includes(order_items: :food_item).order(created_at: :desc)
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def create
    begin
      @order = CheckoutService.new(current_user, payment_method: params[:payment_method]).call
      redirect_to orders_path, notice: "Order placed successfully!"
    rescue => e
      redirect_to cart_path, alert: e.message
    end
  end

  def update
    @order = Order.find(params[:id])
    new_status = params[:status]

    redirect_path = request.referer&.include?('dashboard/orders') ? dashboard_orders_path : dashboard_path

    if Order.statuses.keys.include?(new_status) && @order.update(status: new_status)
      redirect_to redirect_path, notice: "Order ##{@order.id} status updated to #{new_status.humanize}!"
    else
      error_message = @order.errors.full_messages.join(", ")
      error_message = "Invalid status provided" if error_message.blank?
      redirect_to redirect_path, alert: "Failed to update order status: #{error_message}"
    end
  end
end
