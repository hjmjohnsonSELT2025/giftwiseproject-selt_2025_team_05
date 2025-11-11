class SessionsController < ApplicationController
  def home
    render :welcome
  end

  def create
    render :signup
    #redirect_to new_user_path, controller: 'users'
  end
  def new
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      #sucessful authentication
      session[:user_id] = @user.id
    else
      #unsuccessful
      flash.now[:notice] = "Invalid email or password."
      render :welcome
    end
  end
end