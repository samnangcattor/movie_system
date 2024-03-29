class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  before_action :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery with: :exception
  include CanCan::ControllerAdditions

  protected
  def configure_permitted_parameters
     devise_parameter_sanitizer.permit(:sign_in) {|u| u.permit(:login, :email)}
  end
end
