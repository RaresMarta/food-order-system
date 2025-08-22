require "rails_helper"

RSpec.describe Api::V1::SessionsController, type: :routing do
  it "routes POST /api/v1/users/login to sessions#create" do
    expect(post: "/api/v1/users/login").to route_to(
      "api/v1/sessions#create",
      format: :json
    )
  end
end
