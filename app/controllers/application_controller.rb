class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?


  protected

  def configure_permitted_parameters
    #可將permit參數一起放在陣列裡面即可
    devise_parameter_sanitizer.permit(:sign_up, keys: [:bio])
    devise_parameter_sanitizer.permit(:account_update, keys: [:bio])
  end
end
