module OAuthHelpers
  def ensure_oauth_app!
    if ENV["OAUTH_CLIENT_ID"].present?
      Doorkeeper::Application.find_or_create_by!(uid: ENV["OAUTH_CLIENT_ID"]) do |a|
        a.name = "RSpec App"
        a.redirect_uri = "https://example.com/callback"
        a.scopes = "read write"
        a.secret = ENV["OAUTH_CLIENT_SECRET"].presence || "test-secret"
      end
    else
      app = Doorkeeper::Application.create!(
        name: "RSpec App",
        redirect_uri: "https://example.com/callback",
        scopes: "read write"
      )
      ENV["OAUTH_CLIENT_ID"]  = app.uid
      ENV["OAUTH_CLIENT_SECRET"] ||= app.secret
    end
  end

  def api_login!(email:, password:)
    ensure_oauth_app!
    post "/api/v1/users/login", params: { user: { email:, password: } }, as: :json
    expect(response).to have_http_status(:created)
    JSON.parse(response.body)
  end

  def auth_header_from_login(email:, password:)
    body  = api_login!(email:, password:)
    token = body.dig("data", "user", "auth", "access_token")
    { "Authorization" => "Bearer #{token}" }
  end

  def json
    JSON.parse(response.body)
  end
end
