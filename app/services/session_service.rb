class SessionService
  def authenticate_user(email, password)
    user = User.find_by(email: email)

    if user && user.authenticate(password)
      { success: true, message: "Logged in successfully!", user: user }
    else
      { success: false, message: "Invalid email or password" }
    end
  end

  def logout_user
    { success: true, message: "Logged out successfully!" }
  end

  def handle_redirect_reason(redirect_reason)
    case redirect_reason
    when "cart"
      { success: false, message: "You must be logged in to add items to your cart" }
    else
      nil
    end
  end
end
