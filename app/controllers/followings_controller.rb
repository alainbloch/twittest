class FollowingsController < ApplicationController
  before_filter :login_required, :get_user, :user_required
  
  def create
    respond_to do |format|
      if @user.followings.create(:follower => current_user)
        message = "You are now following #{current_user.full_name}"
        format.html do
          flash[:notice] = message
          redirect_to user_path(@user)
        end
        format.js{render(:update){|page| page.alert message}}
      else
        message = "Something went wrong!"
        format.html do
          flash[:error] = message
          redirect_to user_path(@user)
        end
        format.js{render(:update){|page| page.alert message}}
      end
    end
  end
  
  def destroy
    respond_to do |format|
      following = @user.followings.find_by_follower_id(current_user)
      if not following.nil? and following.destroy
        message = "You are not following #{current_user.full_name} anymore"
        format.html do
          flash[:notice] = message
          redirect_to user_path(@user)
        end
        format.js{render(:update){|page| page.alert message}}
      else
        message = "Something went wrong!"
        format.html do
          flash[:error] = message
          redirect_to user_path(@user)
        end
        format.js{render(:update){|page| page.alert message}}
      end
    end
  end
  
private

  def get_user
    @user = User.find_by_id(params[:user_id])
  end
  
  def user_required
    if @user.nil?
      respond_to do |format|
        message = "User hasn't been selected"
        format.js {render(:update){|page| page.alert message}}
        format.html do
          flash[:error] = message
          redirect_to :back
        end
      end
    end
  end
  
end
