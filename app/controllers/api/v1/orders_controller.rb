# frozen_string_literal: true

module Api
  module V1
    class OrdersController < BaseController
      before_action :set_order, only: [ :show, :update ]

      # GET /api/v1/orders
      def index
        @orders = current_user.orders.includes(order_items: :food_item).recent

        render_success({
          orders: @orders.map { |order| OrderSerializer.new(order).as_json }
        })
      end

      # GET /api/v1/orders/:id
      def show
        render_success({
          order: OrderSerializer.new(@order).as_json
        })
      end

      # POST /api/v1/orders
      def create
        result = OrderService.checkout(current_user, payment_method: order_params[:payment_method])

        if result[:success]
          render_success({
            order: OrderSerializer.new(result[:order]).as_json
          }, message: result[:message], status: :created)
        else
          render_error_message(result[:message], status: :unprocessable_entity)
        end
      end

    # PATCH /api/v1/orders/:id
    def update
      order = current_user.orders.find(params[:id])

      desired = order_params[:status]
      return render_error_message("status is required", status: :unprocessable_entity) if desired.blank?

      unless desired == "canceled"
        return render_error_message("You can only cancel your order.", status: :forbidden)
      end

      unless order.cancelable?
        return render_error_message("Order can no longer be canceled.", status: :unprocessable_entity)
      end

      result = OrderService.new(order).update_status("canceled", current_user)

      if result[:success]
        render_success({ order: OrderSerializer.new(result[:order]).as_json }, message: result[:message])
      else
        render_error_message(result[:message], status: :unprocessable_entity)
      end
    end

      private

        def set_order
          @order = current_user.orders.find(params[:id])
        end

        def order_params
          params.require(:order).permit(:payment_method, :status)
        end
    end
  end
end
