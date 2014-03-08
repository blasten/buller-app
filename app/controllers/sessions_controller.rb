class SessionsController < ApplicationController
  before_filter :not_signed_in_user, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to root_path
    else
      flash.now[:error] = 'Invalid email or password'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end


  private
    def not_signed_in_user
      redirect_to root_path unless !signed_in?
    end
end
