class UsersController < ApplicationController
  
  before_filter :get_user, :only => [:show, :edit, :update, :destroy, :followers, :follows]
  before_filter :correct_user_required, :only => [:edit, :update, :destroy]
  
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
    respond_to do |format|
    @messages = @user.messages.paginate(:page => params[:page], :per_page => 8, :order => "created_at DESC")
    format.html{} #show.html.erb
    format.js{ render @messages }
    end
  end
  
  def edit
    # get_user
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = "User has been updated."
      redirect_to user_path(@user.username)
    else
      flash[:error]  = "Something went wrong."
      render :action => "edit"
    end
  end
  
  def destroy
    @user.destroy
    redirect_to logout_path
  end
  
  def follows
    @users_followed = @user.users_followed.paginate(:page => params[:page])
  end
  
  def followers
    @followers = @user.followers.paginate(:page => params[:page])
  end
  
private
  
  def get_user
    @user = User.find_by_username(params[:id])
  end
  
  def correct_user_required
    redirect_to login_url unless @user == current_user
  end

end
