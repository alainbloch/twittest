class HomeController < ApplicationController
  
  def index
    @messages = 
    if logged_in?
      current_user.feed.paginate(:page => params[:page])
    else
      Message.find(:all, :limit => 20, :order => "created_at ASC")
    end
    respond_to do |format|
      format.html do
        if logged_in?
          @user = current_user
          @message = Message.new
          render :template => "/home/dashboard"
        end
      end
      format.js do
      render @messages
      end
    end
  end
  
end
