class SessionsController < ApplicationController
  skip_before_action :require_login

  # GET /login
  def new
    if params[:redirect_reason] == 'cart'
      flash.now[:alert] = "You must be logged in to add items to your cart"
    end
  end

  # POST /login
  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Logged in successfully!"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /logout
  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out successfully!"
  end
end
