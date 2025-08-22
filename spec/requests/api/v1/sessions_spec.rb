# spec/requests/api/v1/sessions_spec.rb
require "rails_helper"

RSpec.describe "API V1 Sessions", type: :request do
  let(:password) { "Password123!" }
  let(:user) { create(:user, email: "bob@example.com", password:, password_confirmation: password) }

  describe "POST /api/v1/users/login" do
    it "returns tokens and user payload" do
      ensure_oauth_app!
      post "/api/v1/users/login.json", params: { user: { email: user.email, password: } }, as: :json

      expect(response).to have_http_status(:created)
      expect(json["message"]).to eq("Logged in")
      expect(json.dig("data", "user", "email")).to eq("bob@example.com")

      auth = json.dig("data", "user", "auth")
      expect(auth).to be_present
      %w[access_token token_type expires_in refresh_token scope created_at].each do |k|
        expect(auth.key?(k)).to be(true), "expected auth to include #{k}"
      end
      expect(auth["token_type"]).to eq("Bearer")
    end

    it "rejects bad credentials" do
      ensure_oauth_app!
      post "/api/v1/users/login.json", params: { user: { email: user.email, password: "wrong" } }, as: :json
      expect(response).to have_http_status(:unauthorized)

      # tolerate either `error`, `errors`, or an error `message`
      body = json rescue {}
      err  = body["error"] || body["errors"] || body["message"]
      expect(err).to be_present
    end
  end

  describe "DELETE /api/v1/users/logout" do
    it "revokes the token and prevents further access" do
      headers = auth_header_from_login(email: user.email, password:)
      delete "/api/v1/users/logout.json", headers:, as: :json

      expect(response).to have_http_status(:ok)
      expect(json.dig("data", "revoked")).to eq(true)

      # same token should now fail
      get "/api/v1/users/me.json", headers:, as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
