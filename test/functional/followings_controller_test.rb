require 'test_helper'

class FollowingsControllerTest < ActionController::TestCase
  
  context "creating a following" do
    
    context "when logged in" do
      
      setup do
        @user = users(:foo)
        @other_user = users(:bar)
        Following.destroy_all
      end
      
      context "using javascript" do
                
        should "be successful with a valid user" do
          assert_difference "Following.count" do
            post :create, {:user_id => @other_user.id, :format => :js}, {:user_id => @user.id}
          end
        end
      
        should "not be successful without a valid user" do
          assert_no_difference "Following.count" do
            post :create, {:user_id => nil, :format => :js}, {:user_id => @user.id}
          end
        end

      end
      
      context "using http" do
                
        should "be successful with a valid user" do
          assert_difference "Following.count" do
            post :create, {:user_id => @other_user.id}, {:user_id => @user.id}
          end
        end
      
        should "not be successful without a valid user" do
          assert_no_difference "Following.count" do
            post :create, {:user_id => nil}, {:user_id => @user.id}
          end
        end
        
      end
      
    end
    
    context "when not logged in" do
      setup do
        post :create, :user_id => users(:foo).id
      end
      should_respond_with :redirect
      should_redirect_to('login path'){ login_path }
    end
    
  end
  
  context "removing a following" do
    
    context "when logged in" do
      
      setup do
      
      end
      
    end
    
    context "when not logged in" do
      setup do
        delete :destroy, :user_id => users(:foo).id
      end
      should_respond_with :redirect
      should_redirect_to('login path'){ login_path }
    end
        
  end

end
