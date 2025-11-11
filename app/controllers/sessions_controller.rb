class SessionsController < ApplicationController
  def home
    render :welcome
  end


  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      #sucessful authentication
      session[:user_id] = @user.id
    else
      #unsuccessful
      flash.now[:notice] = "Login unsuccessful."
      render :welcome
    end
  end
end