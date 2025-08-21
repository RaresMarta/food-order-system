# frozen_string_literal: true

module Api
  module V1
    class OrdersController < BaseController
      before_action :set_order, only: [:show, :update]

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
        order = current_user.admin? ? Order.find(params[:id]) : current_user.orders.find(params[:id])
        result = OrderService.new(order).update_status(order_params[:status], current_user)

        if result[:success]
          render_success({
            order: OrderSerializer.new(result[:order]).as_json
          }, message: result[:message])
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
