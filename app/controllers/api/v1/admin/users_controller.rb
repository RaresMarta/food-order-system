module Api
  module V1
    module Admin
      class UsersController < BaseController
        # GET /api/v1/users/all
        def index
          users = User.all
          render_success(UserSerializer.new(users).serialize)
        end
      end
    end
  end
end
