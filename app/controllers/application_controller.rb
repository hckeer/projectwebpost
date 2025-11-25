class ApplicationController < ActionController::Base
  include Pundit::Authorization

  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  helper_method :current_theme

  def current_theme
    cookies[:theme] || 'light'
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :bio, :avatar_image])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :bio, :avatar_image])
  end

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: root_path)
  end

  def require_admin!
    unless current_user&.admin?
      flash[:alert] = "Admin access required."
      redirect_to root_path
    end
  end
end
