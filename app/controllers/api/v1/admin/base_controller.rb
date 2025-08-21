# frozen_string_literal: true

module Api
  module V1
    module Admin
      class BaseController < Api::V1::BaseController
        before_action :doorkeeper_authorize!
        before_action :admin_required

        protected

          def render_validation_errors(resource, message: 'Validation failed')
            render json: {
              message: message,
              errors: resource.errors.full_messages,
              code: 'validation_error'
            }, status: :unprocessable_entity
          end

          def render_resource_success(resource, serializer_class, message: 'Success', status: :ok)
            render_success(
              { resource.class.name.underscore => serializer_class.new(resource).as_json },
              message: message,
              status: status
            )
          end

          def render_created_resource(resource, serializer_class, message: 'Resource created successfully')
            render_resource_success(resource, serializer_class, message: message, status: :created)
          end

          def render_updated_resource(resource, serializer_class, message: 'Resource updated successfully')
            render_resource_success(resource, serializer_class, message: message, status: :ok)
          end

          def render_destroyed_resource(resource, serializer_class, message: 'Resource deleted successfully')
            render_resource_success(resource, serializer_class, message: message, status: :ok)
          end
      end
    end
  end
end
