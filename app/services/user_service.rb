class UserService
  def register_user(user_params)
    user = User.new(user_params)

    if user.save
      { success: true, message: "Account created successfully!", user: user }
    else
      { success: false, message: "Failed to create account", user: user }
    end
  end
end
