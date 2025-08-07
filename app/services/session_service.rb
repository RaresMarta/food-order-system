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
end
