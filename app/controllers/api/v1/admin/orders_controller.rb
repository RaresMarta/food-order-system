# frozen_string_literal: true

module Api
  module V1
    module Admin
      class OrdersController < BaseController
        before_action :set_order, only: [ :update ]

        # PATCH /api/v1/admin/orders/:id
        def update
          result = OrderService.new(@order).update_status(order_params[:status], current_user)

          if result[:success]
            render_updated_resource(result[:order], OrderSerializer, message: result[:message])
          else
            render_validation_errors(result[:order], message: result[:message])
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
