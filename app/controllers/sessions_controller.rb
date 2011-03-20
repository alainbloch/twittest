class SessionsController < ApplicationController
  def new
    @user = UserSession.new
  end
  
  def create
    @user = UserSession.new(params[:user])    
    if @user.save
      flash[:notice] = "Logged in successfully."
      redirect_to_target_or_default(root_url)
    else
      flash.now[:error] = "Invalid login or password."
      render :action => 'new'
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "You have been logged out."
    redirect_to root_url
  end
end
