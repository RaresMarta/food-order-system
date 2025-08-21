module Api
  module V1
    class SessionsController < BaseController
      skip_before_action :doorkeeper_authorize!, only: [ :create ]

      # POST /api/v1/users/login
      def create
        user = User.find_for_authentication(email: sign_in_params[:email].to_s.strip.downcase)

        unless user&.valid_password?(sign_in_params[:password]) && user.active_for_authentication?
          return render json: { ok: false, error: I18n.t("devise.failure.invalid", authentication_keys: :email) }, status: :unauthorized
        end

        tokens = TokenIssuer.new(user).call
        render json: UserSerializer.new(user, params: { include_tokens: tokens }).serialize
      end

      # DELETE /api/v1/users/logout
      def destroy
        token = doorkeeper_token || Doorkeeper::AccessToken.by_token(bearer_token)
        if token.nil?
          return render json: { ok: false, error: "invalid_token" }, status: :unprocessable_entity
        end

        if token.revoked?
          render json: { ok: true, message: "already_revoked" }
        else
          token.revoke
          Doorkeeper::AccessToken
            .where(previous_refresh_token: token.refresh_token)
            .update_all(revoked_at: Time.current)
          render json: { ok: true, message: "logged_out" }
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
