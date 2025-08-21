# frozen_string_literal: true

module Api
  module V1
    class CartItemsController < BaseController
      before_action :set_cart_item, only: [:update, :destroy]
      before_action :initialize_cart_service

      # GET /api/v1/cart_items
      def index
        @cart_items = current_user.cart_items.includes(:food_item)
        @total = @cart_service.cart_total

        render_success({
          cart_items: @cart_items.map { |cart_item|
            {
              id: cart_item.id,
              quantity: cart_item.quantity,
              food_item: FoodItemSerializer.new(cart_item.food_item).as_json,
              subtotal: cart_item.quantity * cart_item.food_item.price
            }
          },
          total: @total.to_f
        })
      end

      # POST /api/v1/cart_items
      def create
        if cart_item_params[:order_id].present?
          order = current_user.orders.find_by(id: cart_item_params[:order_id])
          result = @cart_service.add_items_from_order(order)
        else
          result = @cart_service.add_item(cart_item_params[:food_item_id])
        end

        if result[:success]
          @cart_items = current_user.cart_items.includes(:food_item)
          @total = @cart_service.cart_total

          render_success({
            cart_items: @cart_items.map { |cart_item|
              {
                id: cart_item.id,
                quantity: cart_item.quantity,
                food_item: FoodItemSerializer.new(cart_item.food_item).as_json,
                subtotal: cart_item.quantity * cart_item.food_item.price
              }
            },
            total: @total.to_f
          }, message: result[:message], status: :created)
        else
          render_error_message(result[:message], status: :unprocessable_entity)
        end
      end

      # PATCH /api/v1/cart_items/:id
      def update
        result = @cart_service.update_item(@cart_item, cart_item_params[:quantity])

        if result[:success]
          @cart_items = current_user.cart_items.includes(:food_item)
          @total = @cart_service.cart_total

          render_success({
            cart_items: @cart_items.map { |cart_item|
              {
                id: cart_item.id,
                quantity: cart_item.quantity,
                food_item: FoodItemSerializer.new(cart_item.food_item).as_json,
                subtotal: cart_item.quantity * cart_item.food_item.price
              }
            },
            total: @total.to_f
          }, message: result[:message])
        else
          render_error_message(result[:message], status: :unprocessable_entity)
        end
      end

      # DELETE /api/v1/cart_items/:id
      def destroy
        result = @cart_service.remove_item(@cart_item)

        if result[:success]
          @cart_items = current_user.cart_items.includes(:food_item)
          @total = @cart_service.cart_total

          render_success({
            cart_items: @cart_items.map { |cart_item|
              {
                id: cart_item.id,
                quantity: cart_item.quantity,
                food_item: FoodItemSerializer.new(cart_item.food_item).as_json,
                subtotal: cart_item.quantity * cart_item.food_item.price
              }
            },
            total: @total.to_f
          }, message: result[:message])
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
