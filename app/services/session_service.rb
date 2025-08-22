class SessionService
  def login(email, password)
    user = User.find_for_authentication(email: email.to_s.strip.downcase)

    unless user&.valid_password?(password) && user.active_for_authentication?
      return {
        success: false,
        message: I18n.t("devise.failure.invalid", authentication_keys: :email)
      }
    end

    tokens = TokenIssuer.new(user).call

    {
      success: true,
      message: "Logged in",
      user: user,
      tokens: tokens
    }
  end

  def logout(token)
    return { success: false, message: "invalid_token" } if token.nil?

    if token.revoked?
      { success: true, message: "Already revoked", revoked: true }
    elsif token.revoke
      { success: true, message: "Logged out", revoked: true }
    else
      { success: false, message: "Failed to revoke token" }
    end
  end
end
