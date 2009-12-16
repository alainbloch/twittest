require 'test_helper'

class FollowingsControllerTest < ActionController::TestCase
  
  context "creating a following" do
    
    context "when logged in" do
      
      setup do
        @user = users(:foo)
        @other_user = users{:bar}
        Following.destroy_all
      end
      
      context "using javascript" do
                
        should "be successful with a valid user" do
          assert_difference @user.reload.followings.count do
            post :create, {:id => @other_user.id, :format => :js}, {:user_id => @user.id}
            assert_response :success
          end
        end
      
        should "not be successful without a valid user" do
          assert_no_difference @user.reload.followings.count do
            post :create, {:id => nil, :format => :js}, {:user_id => @user.id}
            assert_response :error
          end
        end

      end
      
      context "using http" do
                
        should "be successful with a valid user" do
          assert_difference @user.reload.followings.count do
            post :create, {:id => @other_user.id}, {:user_id => @user.id}
            assert_response :success
          end
        end
      
        should "not be successful without a valid user" do
          assert_no_difference @user.reload.followings.count do
            post :create, {:id => nil}, {:user_id => @user.id}
            assert_response :error
          end
        end
        
      end
      
    end
    
    context "when not logged in" do
      setup do
        post :create, :id => users(:foo).id
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
        delete :destroy, :id => users(:foo).id
      end
      should_respond_with :redirect
      should_redirect_to('login path'){ login_path }
    end
        
  end

end
