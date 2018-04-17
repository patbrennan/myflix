class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_user

  def logged_in?
    session[:user_id] && current_user
  end

  def require_user
    unless @user
      flash[:error] = "Access denied. Please create an account or log in."
      redirect_to login_path
    end
  end

  def current_user
    User.find(session[:user_id])
  end

  def require_same_user
    unless @user && params[:user_id] == @user.id
      flash[:error] = "Access denied."
      redirect_to login_path
    end
  end

  private

  def set_user
    @user ||= current_user if session[:user_id]
  end
end
