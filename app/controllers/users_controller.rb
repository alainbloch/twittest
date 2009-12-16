class UsersController < ApplicationController
  
  before_filter :get_user, :only => [:show, :edit]
  before_filter :correct_user_required, :only => [:edit]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Thank you for signing up! You are now logged in."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end

  def show
    # get_user
  end
  
  def edit
    # get_user
  end
  
  def update
    
  end
  
  def destroy
    
  end
  
private
  
  def get_user
    @user = User.find_by_id(params[:id])
  end
  
  def correct_user_required
    redirect_to login_url unless @user == current_user
  end

end
