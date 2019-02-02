class UsersController < ApplicationController
  def new
  end

  def create
    user = User.new(user_params)
    if user.save
      login!(user)
      flash[:success] = "Welcome!"
      redirect_to user_url(user)
    else
      flash[:failure] = user.errors.full_messages
      redirect_to new_user_url
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.all
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end