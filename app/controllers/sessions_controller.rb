class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password])
      flash[:success] = "You are logged in."
      session[:user_id] = @user.id
      redirect_to home_path
    else
      flash[:error] = "Authentication failed. Please try again."
      render :new
    end
  end

  def destroy
    flash[:success] = "You are logged out."
    session[:user_id] = nil
    redirect_to login_path
  end
end