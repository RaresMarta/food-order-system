class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def require_admin
    unless current_user&.admin?
      result = { success: false, message: "Access denied. Admin privileges required." }
      handle_result(result, root_path)
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name ])
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

  helper_method :current_user_admin?

  def current_user_admin?
    user_signed_in? && current_user.admin?
  end
end
