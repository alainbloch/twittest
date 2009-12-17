class MessagesController < ApplicationController
  before_filter :login_required
  
  def create
    @message = current_user.messages.new(params[:message])
    respond_to do |format|
      if @message.save
        message = "Your message has been sent!"
        format.html do
          flash[:success] = message
          redirect_to root_url
        end
        format.js{render(:update){|page| page.alert message}}
      else
        message = "An error has occurred."
        format.html do
          flash[:error] = message
          redirect_to root_url
        end
        format.js{render(:update){|page| page.alert message}}
      end
    end
  end
  
end
