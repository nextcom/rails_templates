# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  helper_method :current_user_session, :current_user, :admin?

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation

  private
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def admin?
    current_user && current_user.admin?
  end
  
  def require_admin
    unless current_user && current_user.admin?
      store_location
      flash[:warning] = "You must be an administrator to access this page"
      redirect_back_or_login
      return false
    end
  end
  
  def require_admin_or_owner
    unless current_user  && (current_user.admin? || current_user.id == params[:id].to_i)
      store_location
      flash[:warning] = "You must be authorized to access this page"
      redirect_back_or_login
      return false
    end
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_path
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to user_path(current_user)
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def redirect_back_or_login
    if current_user && !request.env["HTTP_REFERER"].nil?
      redirect_to(:back)
    else
      redirect_to(login_path)
    end
  end
  
  def check_admin_layout
    if current_user && current_user.admin?
      'admin'
    else
      'application'
    end
  end
  
end
