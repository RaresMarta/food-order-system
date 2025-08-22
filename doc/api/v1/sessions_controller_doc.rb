module Api
  module V1
    module SessionsControllerDoc
      extend ActiveSupport::Concern

      included do
        extend Apipie::DSL::Concern

        resource_description do
          resource_id 'Sessions'
          name 'Sessions'
          short 'User authentication (login/logout)'
          formats %w(json)
          api_version 'v1'
        end

        api :POST, '/users/login', 'Log in'
        param :email, String, required: true
        param :password, String, required: true
        error 401, 'Invalid credentials'
        def create; end

        api :DELETE, '/users/logout', 'Log out'
        header 'Authorization', 'Bearer <access_token>', required: true
        error 422, 'invalid_token'
        def destroy; end
      end
    end
  end
end
