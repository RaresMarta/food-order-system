class TokenIssuer
  def initialize(user, scopes: "read")
    @user   = user
    @scopes = scopes
  end

  def call
    app = Doorkeeper::Application.find_by!(uid: ENV.fetch("OAUTH_CLIENT_ID"))

    token = Doorkeeper::AccessToken.find_or_create_for(
      application:        app,
      resource_owner:     @user.id,
      scopes:             @scopes,
      expires_in:         Doorkeeper.configuration.access_token_expires_in,
      use_refresh_token:  true
    )

    Doorkeeper::OAuth::TokenResponse.new(token).body.with_indifferent_access
  end
end
