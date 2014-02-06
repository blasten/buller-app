class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :not_signed_in_user, only: [:new, :create]

  # # #

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      # Start the session automatically
      sign_in(@user)
      redirect_to users_path, notice: "Your account was successfully created!"
    else
      render 'new'
    end
  end

  # # #

  def show
    @user = User.find(params[:id]) 

  end

  # # #

  def destroy
    @user = User.find(params[:id])
    @user.destroy
   
    redirect_to users_path, notice: "The user account has been deleted."
  end
  
  # # #

  def edit
    @user = User.find(params[:id])
  end
  
  # Writes the user data back to the database
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to users_path(), notice: "Profile updated!"
    else
      render 'edit'
    end
  end

  # Parameters allow in post requests
  private
    def user_params
      params.require(:user).permit(:name, :nickname, :email, :image_url, :password, :password_confirmation)
    end

    # Redirects to `signin_path` if the user hasn't signed in yet
    def signed_in_user
      redirect_to signin_path, :status => 301, :flash => {:error => "Please sign in."} unless signed_in?
    end

    # Checks if the requested user id matches the session user's id
    # Otherwise it will redirect to the root
    def correct_user
      @user = User.find(params[:id])

      # Redirect to the root if the user isn't perform requests on this resource
      redirect_to root_path, :status => 301, :flash => {:error => "You can't do that!"} unless current_user[:id]==@user[:id]

      # Redirect to the root path if the user isn't found
      rescue ActiveRecord::RecordNotFound
        redirect_to root_path, :status => 404
    end

    def not_signed_in_user
      redirect_to root_path unless !signed_in?
    end
end
