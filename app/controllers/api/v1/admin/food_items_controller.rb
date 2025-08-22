# frozen_string_literal: true

module Api
  module V1
    module Admin
      class FoodItemsController < BaseController
        before_action :set_food_item, only: [ :show, :update, :destroy, :reactivate ]
        before_action :initialize_food_item_service, only: [ :create, :update, :destroy ]

        # GET /api/v1/food_items/:id
        def show
          render_resource_success(@food_item, FoodItemAdminSerializer, "Food item fetched.")
        end

        # POST /api/v1/admin/food_items
        def create
          result = @food_item_service.create_item(food_item_params)

          if result[:success]
            render_resource_success(result[:food_item], FoodItemAdminSerializer, result[:message], status: :created)
          else
            render_validation_errors(result[:food_item], message: result[:message])
          end
        end

        # PATCH /api/v1/admin/food_items/:id
        def update
          result = @food_item_service.update_item(@food_item, food_item_params)

          if result[:success]
            render_resource_success(result[:food_item], FoodItemAdminSerializer, result[:message])
          else
            render_validation_errors(result[:food_item], message: result[:message])
          end
        end

        # DELETE /api/v1/admin/food_items/:id
        def destroy
          result = @food_item_service.delete_item(@food_item)

          if result[:success]
            render_resource_success(result[:food_item], FoodItemAdminSerializer, result[:message])
          else
            render_validation_errors(result[:food_item], message: result[:message])
          end
        end

        # PATCH /api/v1/admin/food_items/:id/reactivate
        def reactivate
          if @food_item.update(deleted_at: nil)
            render_resource_success(@food_item, FoodItemAdminSerializer, "Food item reactivated successfully")
          else
            render_error_message("Failed to reactivate item.", status: :unprocessable_entity)
          end
        end

        private

          def initialize_food_item_service
            @food_item_service = FoodItemService.new
          end

          def set_food_item
            @food_item = FoodItem.find_by(id: params[:id])
            unless @food_item
              render_error_message("Food item not found", status: :not_found)
            end
          end

          def food_item_params
            params.require(:food_item).permit(:name, :category, :price, :vegetarian, :image)
          end
      end
    end
  end
end
