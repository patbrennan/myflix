class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_user

  def logged_in?
    session[:user_id] && User.find(session[:user_id])
  end

  def require_user
    @user = User.find(session[:user_id]) if session[:user_id]

    unless @user
      flash[:error] = "Access denied. Please create an account or log in."
      redirect_to login_path
    end
  end

  private

  def set_user
    @user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
