 # frozen_string_literal: true

module Api
  module V1
    module Admin
      class DashboardController < BaseController
        before_action :initialize_dashboard_service

        # GET /api/v1/admin/dashboard
        def index
          stats = @dashboard_service.today_stats

          render_success({
            orders_today: stats[:orders_today],
            total_revenue_today: stats[:total_revenue_today]&.to_f || 0,
            total_food_items: stats[:total_food_items],
            total_orders: stats[:total_orders]
          })
        end

        # GET /api/v1/admin/orders
        def orders
          @all_orders = @dashboard_service.orders

          render_success({
            orders: @all_orders.map { |order| OrderSerializer.new(order).as_json }
          })
        end

        # GET /api/v1/admin/menu
        def menu
          menu_data = @dashboard_service.food_items_for_menu(edit_id: params[:edit_id])

          render_success({
            food_items: menu_data[:food_items].map { |item| FoodItemSerializer.new(item).as_json },
            food_item: menu_data[:food_item] ? FoodItemSerializer.new(menu_data[:food_item]).as_json : nil
          })
        end

        private

          def initialize_dashboard_service
            @dashboard_service = DashboardService.new
          end
      end
    end
  end
end
