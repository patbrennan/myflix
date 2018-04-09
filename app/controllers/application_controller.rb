class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def logged_in?
    session[:user_id] && User.find(session[:user_id])
  end

  def require_user
    @user = User.find(session[:user_id]) if session[:user_id]

    unless @user
      flash[:error] = "Access denied. Please create an account or log in."
      redirect_to root_path
    end
  end
end
