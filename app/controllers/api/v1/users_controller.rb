module Api
  module V1
    class UsersController < BaseController
      skip_before_action :doorkeeper_authorize!, only: [:create]
      # POST /api/v1/users/register
      def create
        user = User.new(user_params)
        if user.save
          render json: UserSerializer.new(user).serialize, status: :created
        else
          render json: { ok: false, errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # GET /api/v1/users/me
      def show
        user = User.find(doorkeeper_token.resource_owner_id)
        render json: UserSerializer.new(user).serialize, status: :ok
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end
    end
  end
end
