# frozen_string_literal: true

module Api
  module V1
    module Admin
      class BaseController < Api::V1::BaseController
        before_action :doorkeeper_authorize!
        before_action :admin_required

        protected

          def render_validation_errors(resource, message: "Validation failed")
            render json: {
              message: message,
              errors: resource.errors.full_messages,
              code: "validation_error"
            }, status: :unprocessable_entity
          end

          def render_resource_success(resource, serializer_class, message, status: :ok)
            render_success(
              hash_resource(resource, serializer_class).as_json,
              message: message,
              status: status
            )
          end

        private

          def hash_resource(resource, serializer_class)
            { resource.class.name.underscore => serializer_class.new(resource) }
          end
      end
    end
  end
end
