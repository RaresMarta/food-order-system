# frozen_string_literal: true
Doorkeeper.configure do
  orm :active_record

  resource_owner_authenticator do
    current_user || warden.authenticate!(scope: :user)
  end

  resource_owner_from_credentials do |_routes|
    user = User.find_by(email: params[:username] || params[:email])
    user if user&.valid_password?(params[:password])
  end

  grant_flows %w[password client_credentials authorization_code refresh_token]

  api_only

  use_refresh_token
  reuse_access_token

  default_scopes :read
  optional_scopes :write, :admin

  access_token_generator 'Doorkeeper::JWT'

  skip_authorization do
    true
  end
end
