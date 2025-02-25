class ApplicationController < ActionController::Base
  include CanCan::ControllerAdditions  

  helper_method :current_user  

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to projects_path, alert: "You are not authorized to perform this action."
  end
end
