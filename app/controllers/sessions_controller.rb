class SessionsController < ApplicationController
  skip_before_action :require_login
  before_action :initialize_session_service

  def new
    result = @session_service.handle_redirect_reason(params[:redirect_reason])
    handle_result(result, use_flash_now: true) if result
  end

  def create
    result = @session_service.authenticate_user(params[:email], params[:password])

    if result[:success]
      session[:user_id] = result[:user].id
      handle_result(result, root_path)
    else
      handle_result(result, use_flash_now: true)
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    result = @session_service.logout_user
    session[:user_id] = nil
    handle_result(result, root_path)
  end

  private

  def initialize_session_service
    @session_service = SessionService.new
  end
end
