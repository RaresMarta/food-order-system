# frozen_string_literal: true

class Api::V1::AuthController < Api::V1::BaseController
  before_action :doorkeeper_authorize!

  def me
    user = User.find(doorkeeper_token.resource_owner_id)
    render json: { ok: true, user: { id: user.id, email: user.email } }
  end

  def logout
    token_str = bearer_token || params[:token]
    return render json: { ok: false, error: "missing_token" }, status: :bad_request if token_str.blank?

    token = Doorkeeper::AccessToken.by_token(token_str)

    if token.nil?
      render json: { ok: false, error: "invalid_token" }, status: :unprocessable_entity
    elsif token.revoked?
      render json: { ok: true, message: "already_revoked" }
    else
      token.revoke
      Doorkeeper::AccessToken.where(previous_refresh_token: token.refresh_token).update_all(revoked_at: Time.current)
      render json: { ok: true, message: "logged_out" }
    end
  end

  private

  def bearer_token
    auth = request.headers["Authorization"].to_s
    auth.start_with?("Bearer ") ? auth.split(" ").last : nil
  end
end
