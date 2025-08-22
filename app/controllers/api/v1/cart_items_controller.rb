# frozen_string_literal: true

module Api
  module V1
    class CartItemsController < BaseController
      before_action :set_cart_item, only: [ :update, :destroy ]
      before_action :initialize_cart_service

      # GET /api/v1/cart_items
      def index
        @cart_items = @cart_service.items
        @total = @cart_service.cart_total

        render_success({
          cart_items: CartItemSerializer.new(@cart_items).as_json,
          total: @total.to_f
        })
      end

      # POST /api/v1/cart_items
      def create
        food_item_id = cart_item_params[:food_item_id]
        return render_error_message("food_item_id is required", status: :unprocessable_entity) if food_item_id.blank?

        result = @cart_service.add_item(food_item_id)
        if result[:success]
          item = current_user.cart_items.includes(:food_item).find_by!(food_item_id: food_item_id)
          render_success(
            { cart_item: CartItemSerializer.new(item).as_json },
            message: result[:message],
            status: :created
          )
        else
          render_error_message(result[:message], status: :unprocessable_entity)
        end
      end

      # PATCH /api/v1/cart_items/:id
      def update
        quantity = cart_item_params[:quantity]
        return render_error_message("quantity is required", status: :unprocessable_entity) if quantity.blank?

        result = @cart_service.update_item(@cart_item, quantity)

        if result[:success]
          @cart_item.reload
          render_success(
            { cart_item: CartItemSerializer.new(@cart_item).as_json },
            message: result[:message]
          )
        else
          render_error_message(result[:message], status: :unprocessable_entity)
        end
      end

      # DELETE /api/v1/cart_items/:id
      def destroy
        deleted_item_json = CartItemSerializer.new(@cart_item).as_json

        result = @cart_service.remove_item(@cart_item)

        if result[:success]
          render_success(
            { deleted_item: deleted_item_json },
            message: result[:message]
          )
        else
          render_error_message(result[:message], status: :unprocessable_entity)
        end
      end

      private

        def initialize_cart_service
          @cart_service = CartService.new(current_user)
        end

        def set_cart_item
          @cart_item = current_user.cart_items.find(params[:id])
        end

        def cart_item_params
          params.require(:cart_item).permit(:quantity, :food_item_id, :order_id)
        end
    end
  end
end
