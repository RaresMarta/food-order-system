class UsersController < ApplicationController
  skip_before_action :require_login
  before_action :initialize_user_service, only: [ :create ]

  # GET /register
  def new
    @user = User.new
  end

  # POST /register
  def create
    result = @user_service.register_user(user_params)

    if result[:success]
      session[:user_id] = result[:user].id
      handle_result(result, root_path)
    else
      @user = result[:user]
      render :new, status: :unprocessable_entity
    end
  end

  private

  def initialize_user_service
    @user_service = UserService.new
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
