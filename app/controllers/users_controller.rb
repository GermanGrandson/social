class UsersController < ApplicationController
before_action :logged_in_user, only:[:index, :edit, :update, :destroy]
before_action :correct_user, only: [:edit, :update]
before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    # debugger
  end

  def create
    @user = User.new(user_params)
    if
      @user.save #if a successful save
      log_in(@user) #calling log_in METHOD in Session helper
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
      # debugger
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if
      @user.update_attributes(user_params) #uses strong parameters to prevent mass assingment from method below
      flash[:success] = "Profile Updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User Deleted'
    redirect_to users_url
  end

private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = 'Please Log In!'
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find(params[:id])
    unless @user == current_user
    redirect_to(root_url)
    end
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end
