# frozen_string_literal: true

Doorkeeper::JWT.configure do
  secret_key Rails.application.credentials.secret_key_base

  token_payload do |opts|
    resource_owner = opts[:resource_owner]

    payload = {
      exp: (opts[:created_at] + opts[:expires_in]).utc.to_i,
      iss: "food-order-system",
      iat: opts[:created_at].utc.to_i,
      jti: SecureRandom.uuid,
      sub: resource_owner&.id,
      aud: "food-order-system"
    }

    if resource_owner
      payload[:email] = resource_owner.email if resource_owner.respond_to?(:email)
      payload[:role] = resource_owner.respond_to?(:admin?) && resource_owner.admin? ? "admin" : "user"
    end

    payload
  end
end
