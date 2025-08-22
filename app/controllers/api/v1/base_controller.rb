# frozen_string_literal: true

module Api
  module V1
    class BaseController < ActionController::API
      include ApiErrorHandling

      before_action :doorkeeper_authorize!
      before_action :set_current_user

      protected

        def doorkeeper_unauthorized_render_options(error: nil)
          {
            json: {
              code: error&.state || "unauthorized",
              message: "Authentication required",
              expired: error&.reason == :expired,
              errors: [ "Invalid or expired access token" ]
            },
            status: :unauthorized
          }
        end

        def render_error_message(message = nil, status: :unprocessable_entity)
          render json: {
            message: "Error",
            errors: Array.wrap(message),
            code: status.to_s
          }, status: status
        end

        def render_success(data = {}, message: "Success", status: :ok)
          render json: {
            message: message,
            data: data,
            code: status.to_s
          }, status: status
        end

        def set_current_user
          @current_user = User.find(doorkeeper_token[:resource_owner_id]) if doorkeeper_token.present?
        end

        def current_user
          @current_user
        end

        def token_payload(token = doorkeeper_token)
          return nil unless token
          {
            access_token: token.token,
            token_type:   "Bearer",
            scope:        token.scopes.to_s,
            expires_in:   token.expires_in_seconds,
            created_at:   token.created_at.to_i
          }.compact
        end

        def admin_required
          render_error_message("Admin access required", status: :forbidden) unless current_user&.admin?
        end
    end
  end
end
