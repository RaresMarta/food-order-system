require "rails_helper"

RSpec.describe "API V1 Admin Users", type: :request do
  it "returns users for admins" do
    admin = create(:user, :admin, email: "admin@example.com")
    create_list(:user, 3)

    headers = auth_header_from_login(email: admin.email, password: "Password123!")

    get "/api/v1/admin/users.json", headers:, as: :json
    expect(response).to have_http_status(:ok)

    users = json.dig("data", "users")
    expect(users).to be_an(Array)
    expect(users.first.keys).to include("id", "name", "email", "role")
  end
end
