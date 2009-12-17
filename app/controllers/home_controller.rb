class HomeController < ApplicationController
  
  def index
    if logged_in?
      @user = current_user
      @feed = current_user.feed.paginate(:page => params[:page])
      @message = Message.new
      render :template => "/home/dashboard"
    else
      @feed = Message.find(:all, :limit => 20, :order => "created_at ASC")
    end
  end
  
end
