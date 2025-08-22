module Api
  module V1
    class SessionsController < BaseController
      skip_before_action :doorkeeper_authorize!, only: [:create]

      # POST /api/v1/users/login
      def create
        user = User.find_for_authentication(email: sign_in_params[:email].to_s.strip.downcase)

        unless user&.valid_password?(sign_in_params[:password]) && user.active_for_authentication?
          return render_error_message(
            I18n.t("devise.failure.invalid", authentication_keys: :email),
            status: :unauthorized
          )
        end

        tokens = TokenIssuer.new(user).call

        render_success(
          {
            user: UserSerializer.new(user, params: { include_tokens: tokens }).as_json
          },
          message: "Logged in",
          status: :created
        )
      end

      # DELETE /api/v1/users/logout
      def destroy
        token = doorkeeper_token || Doorkeeper::AccessToken.by_token(bearer_token)
        return render_error_message("invalid_token", status: :unprocessable_entity) if token.nil?

        if token.revoked?
          render_success({ revoked: true }, message: "already_revoked")
        else
          token.revoke
          Doorkeeper::AccessToken.where(previous_refresh_token: token.refresh_token).update_all(revoked_at: Time.current)
          render_success({ revoked: true }, message: "Logged out")
        end
      end

      private

      def sign_in_params
        params.require(:user).permit(:email, :password)
      end

      def bearer_token
        auth = request.headers["Authorization"].to_s
        auth.start_with?("Bearer ") ? auth.split(" ").last : nil
      end
    end
  end
end
