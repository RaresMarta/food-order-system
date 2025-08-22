# spec/requests/api/v1/users_spec.rb
require "rails_helper"

RSpec.describe "API V1 Users", type: :request do
  describe "POST /api/v1/users/register" do
    it "creates a user and returns the expected shape" do
      attrs = attributes_for(:user)
      post "/api/v1/users/register.json",
           params: { user: attrs.slice(:name, :email, :password, :password_confirmation) },
           as: :json

      expect(response).to have_http_status(:created)
      expect(json["message"]).to eq("Success")
      expect(json["code"]).to eq("created")
      expect(json.dig("data", "user", "email")).to eq(attrs[:email].downcase)
      expect(json.dig("data", "user", "role")).to eq("customer")
    end

    it "returns 422 on validation errors" do
      post "/api/v1/users/register.json",
           params: { user: { name: "", email: "bad", password: "x", password_confirmation: "y" } },
           as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      body = json rescue {}
      err  = body["error"] || body["errors"] || body["message"]
      expect(err).to be_present
    end
  end

  describe "GET /api/v1/users/me" do
    let(:user) { create(:user, email: "me@example.com", password: "Password123!", password_confirmation: "Password123!") }

    it "requires auth" do
      get "/api/v1/users/me.json", as: :json
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns current user and embeds token payload from doorkeeper_token" do
      headers = auth_header_from_login(email: user.email, password: "Password123!")
      access_token = headers["Authorization"].split(" ").last

      get "/api/v1/users/me.json", headers:, as: :json
      expect(response).to have_http_status(:ok)
      expect(json.dig("data", "user", "email")).to eq("me@example.com")

      auth = json.dig("data", "user", "auth")
      expect(auth).to be_present
      expect(auth["access_token"]).to eq(access_token)
      expect(auth["token_type"]).to eq("Bearer")
      expect(auth["scope"]).to be_a(String)
      expect(auth["expires_in"]).to be_a(Integer)
      expect(auth["created_at"]).to be_a(Integer)
    end
  end
end
