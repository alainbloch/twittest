require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  context "when creating a user" do

    should "have a new user page" do
      get :new
      assert_template 'new'
    end

    should "redirect a user to the new page if invalid" do
      assert_no_difference "User.count" do
        User.any_instance.stubs(:valid?).returns(false)
        post :create
        assert_template 'new'
      end
    end

    should "redirect to the root page if the created user is valid" do
      assert_difference "User.count" do
        User.any_instance.stubs(:valid?).returns(true)
        post :create
        assert_redirected_to root_url
        assert_equal assigns['user'].id, session['user_id']
      end
    end

  end

  context "when viewing an individual user" do
  
    setup do
      @user = users(:foo)
      @user_id = @user.username
    end
  
    context "when not logged in" do
      setup do      
        get :show, :id => @user_id
      end
      should_assign_to :user
      should_respond_with :success
      should_render_template :show
    end
  
    context "when logged in as the user" do
      setup do
        get :show, {:id => @user_id}, {:user_id => @user.id}
      end
      should_assign_to :user
      should_respond_with :success
      should_render_template :show
    end
  
    context "when logged in as someone else" do
      setup do
        get :show, {:id => @user_id}, {:user_id => users(:bar).id}
      end
      should_assign_to :user
      should_respond_with :success
      should_render_template :show
    end

  end

  context "when trying to edit a user" do
    
    setup do
      @user = users(:foo)
      @user_id = @user.username
    end
  
    context "when not logged in" do
      setup do
        get :edit, {:id => @user_id}, nil
      end
      should_assign_to :user
      should_respond_with :redirect
      should_redirect_to('login path'){ login_path }
    end
  
    context "when logged in as the user" do
      setup do
        get :edit, {:id => @user_id}, {:user_id => @user.id}
      end
      should_assign_to :user
      should_respond_with :success
      should_render_template :edit
    end
  
    context "when logged in as someone else" do
      setup do
        get :edit, {:id => @user_id}, {:user_id => users(:bar).id}
      end
      should_assign_to :user
      should_respond_with :redirect
      should_redirect_to('login path'){ login_path }
    end

  end

  context "when updating a user" do
    
    setup do
      @user       = users(:foo)
      @user_id    = @user.username
      @other_user = users(:bar)
    end
    
    context "when logged in as the user" do
      
      setup do
        
       @good_data = {:user => {
                     :full_name => "Alain Bloch",
                     :username  => "alainbloch",
                     :email => "alainbloch@gmail.com", 
                     :password => "secret", 
                     :password_confirmation => "secret"}}
                     
       @bad_data  = {:user => {
                     :full_name => "Alain Bloch",
                     :username  => "alain bloch",
                     :email => "alain@bloch@gmail.com", 
                     :password => "se33", 
                     :password_confirmation => "cr3t"}}
                     
      end
 
      should "successfully update with good data" do
        put :update, {:id => @user_id}.merge(@good_data), {:user_id => @user.id}
        assert_response :redirect
        assert_redirected_to user_path(@user.reload.username)
        assert_equal "User has been updated.", flash[:notice]
        assert_equal @good_data[:user][:full_name], @user.reload.full_name
      end
    
      should "not update with bad data" do
        put :update, {:id => @user_id}.merge(@bad_data), {:user_id => @user.id}
        assert_response :success
        assert_template 'edit'
        assert_not_nil assigns(:user).errors
      end

    end

    
    context "when logged in as someone else" do
      setup do 
        put :update, {:id => @user_id}, {:user_id => @other_user.id}
      end
      should_respond_with :redirect
      should_redirect_to('login path'){ login_path }
    end
    
    context "when not logged in" do
      setup do
        put :update, {:id => @user_id}
      end
      should_respond_with :redirect
      should_redirect_to('login path'){ login_path }
    end
    
  end
  
  context "when viewing a user's followers" do
    setup do
      get :followers, :id => users(:foo).username
      assert_response :success
    end
    should_assign_to :followers
    
    should_render_template :followers
    
  end
  
  context "when viewing who the user follows" do
    setup do
      get :follows, :id => users(:foo).username
      assert_response :success    
    end
    
    should_assign_to :users_followed
    should_render_template :follows

  end
    
end
