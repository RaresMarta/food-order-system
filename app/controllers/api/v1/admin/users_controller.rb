module Api
  module V1
    module Admin
      class UsersController < BaseController
        # GET /api/v1/users/all
        def index
          users = User.all
          render_success({ users: UserSerializer.new(users).as_json })
        end
      end
    end
  end
end
