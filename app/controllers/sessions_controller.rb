class SessionsController < ApplicationController
  skip_before_action :require_login
  before_action :initialize_session_service

  # GET /login
  def new
    if params[:redirect_reason] == 'cart'
      flash.now[:alert] = "You must be logged in to add items to your cart"
    end
  end

  # POST /login
  def create
    result = @session_service.authenticate_user(params[:email], params[:password])

    if result[:success]
      session[:user_id] = result[:user].id
      redirect_to root_path, notice: result[:message]
    else
      flash.now[:alert] = result[:message]
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /logout
  def destroy
    result = @session_service.logout_user
    session[:user_id] = nil
    redirect_to root_path, notice: result[:message]
  end

  private

  def initialize_session_service
    @session_service = SessionService.new
  end
end
