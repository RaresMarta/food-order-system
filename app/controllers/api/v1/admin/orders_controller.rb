# frozen_string_literal: true

module Api
  module V1
    module Admin
      class OrdersController < BaseController
        before_action :set_order, only: [:update]

        # PATCH /api/v1/admin/orders/:id
        def update
          result = OrderService.new(@order).update_status(order_params[:status], current_user)

          if result[:success]
            render_success({ order: OrderSerializer.new(result[:order]).as_json }, message: result[:message])
          else
            render_error_message(result[:message], status: :unprocessable_entity)
          end
        end

        private

          def set_order
            @order = Order.find(params[:id])
          end

          def order_params
            params.require(:order).permit(:status)
          end
      end
    end
  end
end
