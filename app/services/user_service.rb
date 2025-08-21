class UserService
  def initialize
  end

  def register_user(user_params)
    user = User.new(user_params)

    if user.save
      { success: true, message: "User registered successfully!", user: user }
    else
      { success: false, message: "Failed to register user", user: user }
    end
  end

  def authenticate_user(email, password)
    user = User.find_by(email: email)

    return { success: false, message: "Invalid email or password" } unless user&.valid_password?(password)
    return { success: false, message: "Account not activated" } unless user.active_for_authentication?

    { success: true, message: "Authentication successful", user: user }
  end

  def create_access_token_for_user(user)
    scopes = user.admin? ? 'read write admin' : 'read write'

    access_token = Doorkeeper::AccessToken.create!(
      application_id: nil,
      resource_owner_id: user.id,
      scopes: scopes,
      expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
      use_refresh_token: true
    )

    {
      access_token: access_token.token,
      refresh_token: access_token.refresh_token,
      token_type: "Bearer",
      expires_in: access_token.expires_in,
      expires_at: access_token.expires_at.to_i,
      scopes: scopes.split(' ')
    }
  end

  def refresh_access_token(refresh_token)
    token = Doorkeeper::AccessToken.find_by(refresh_token: refresh_token)

    return { success: false, message: "Invalid refresh token" } unless token&.valid?

    # Create new access token
    new_token = Doorkeeper::AccessToken.create!(
      application_id: token.application_id,
      resource_owner_id: token.resource_owner_id,
      scopes: token.scopes_string,
      expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
      use_refresh_token: true
    )

    # Revoke old token
    token.revoke

    user = User.find(new_token.resource_owner_id)

    {
      success: true,
      user: user,
      access_token: new_token.token,
      refresh_token: new_token.refresh_token,
      token_type: "Bearer",
      expires_in: new_token.expires_in,
      expires_at: new_token.expires_at.to_i,
      scopes: new_token.scopes.to_a
    }
  end
end
