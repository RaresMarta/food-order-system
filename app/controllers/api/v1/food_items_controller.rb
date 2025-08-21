# frozen_string_literal: true

module Api
  module V1
    class FoodItemsController < BaseController
      skip_before_action :doorkeeper_authorize!, only: [:index, :show]
      before_action :set_food_item, only: [:show]

      # GET /api/v1/food_items
      def index
        @food_items = FoodItemQuery.new(params: params).call

        render_success({
          food_items: FoodItemSerializer.new(@food_items).as_json
        })
      end

      # GET /api/v1/food_items/:id
      def show
        render_success({
          food_item: FoodItemSerializer.new(@food_item).as_json
        })
      end

      private

        def set_food_item
          @food_item = FoodItem.find(params[:id])
        end
    end
  end
end
