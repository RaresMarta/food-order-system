# frozen_string_literal: true

module Api
  module V1
    class FoodItemsController < BaseController
      skip_before_action :doorkeeper_authorize!, only: [ :index ]

      # GET /api/v1/food_items
      def index
        @food_items = FoodItemQuery.new(params: params).call

        render_success({
          food_items: FoodItemSerializer.new(@food_items).as_json
        })
      end

      private

        def set_food_item
          @food_item = FoodItemService.new.get_item(params[:id])[:food_item]
        end
    end
  end
end
