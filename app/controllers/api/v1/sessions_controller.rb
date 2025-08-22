module Api
  module V1
    class SessionsController < BaseController
      include Api::V1::SessionsControllerDoc

      skip_before_action :doorkeeper_authorize!, only: [:create]

      # POST /api/v1/users/login
      def create
        result = SessionService.new.login(sign_in_params[:email], sign_in_params[:password])

        if result[:success]
          render_success(
            {
              user: UserSerializer.new(result[:user], params: { include_tokens: result[:tokens] }).as_json
            },
            message: result[:message],
            status: :created
          )
        else
          render_error_message(result[:message], status: :unauthorized)
        end
      end

      # DELETE /api/v1/users/logout
      def destroy
        token = doorkeeper_token || Doorkeeper::AccessToken.by_token(bearer_token)
        result = SessionService.new.logout(token)

        if result[:success]
          render_success({ revoked: result[:revoked] }, message: result[:message])
        else
          render_error_message(result[:message], status: :unprocessable_entity)
        end
      end

      private

      def sign_in_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
