class UserSessionsController < ApplicationController
  
  before_filter :require_user, :only => [:destroy]
  before_filter :require_no_user, :only => [:new, :create]
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Successfully logged in."
      redirect_back_or_default User.find_by_username(@user_session.username).admin? ? admin_url : root_url
    else
      render :action => "new", :status => 401
    end
  end
  
  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = "Successfully logged out."
    redirect_to root_url
  end
end
