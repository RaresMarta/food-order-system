require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  let(:password) { "Password123!" }
  let(:user) { create(:user, password: password, password_confirmation: password, role: :customer) }
  let(:admin) { create(:user, password: password, password_confirmation: password, role: :admin) }

  describe "POST /api/v1/users/register" do
    it "registers a new user" do
      post "/api/v1/users/register", params: {
        user: {
          name: "Jane Doe",
          email: "jane@example.com",
          password: "secret123",
          password_confirmation: "secret123"
        }
      }

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body["email"]).to eq("jane@example.com")
    end

    it "fails with invalid data" do
      post "/api/v1/users/register", params: {
        user: { email: "", password: "123", password_confirmation: "456" }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      body = JSON.parse(response.body)
      expect(body["errors"]).to include("Name can't be blank")
    end
  end

  describe "GET /api/v1/users/me" do
    it "returns current user with valid token" do
      token = Doorkeeper::AccessToken.create!(resource_owner_id: user.id)

      get "/api/v1/users/me", headers: { "Authorization" => "Bearer #{token.token}" }

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["email"]).to eq(user.email)
    end

    it "rejects request without token" do
      get "/api/v1/users/me"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
