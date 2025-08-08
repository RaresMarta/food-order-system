class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :require_login

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_login
    unless logged_in?
      result = { success: false, message: "You must be logged in to access this page" }
      handle_result(result, login_path)
    end
  end

  def require_admin
    unless current_user&.admin?
      result = { success: false, message: "Access denied. Admin privileges required." }
      handle_result(result, root_path)
    end
  end

  def handle_result(result, redirect_path = root_path, use_flash_now: false)
    flash_type = result[:success] ? :notice : :alert

    if use_flash_now
      flash.now[flash_type] = result[:message]
    else
      flash[flash_type] = result[:message]
      redirect_to redirect_path
    end
  end

  helper_method :current_user, :logged_in?
end
