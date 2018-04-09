class UsersController < ApplicationController
  before_action :require_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = "Successfully registered."
      redirect_to login_path
    else
      flash[:error] = "Please correct the errors below."
      render :new
    end
  end

  def edit

  end

  def update

  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end
end