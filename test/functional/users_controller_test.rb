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
      get :show, :id => @user.id
    end
    
    context "when not logged in" do      
      should_assign_to :user
      should_respond_with :success
      should_render_template :show
    end
    
    context "when logged in as the user" do
      should_assign_to :user
      should_respond_with :success
      should_render_template :show
    end
    
    context "when logged in as someone else" do
      should_assign_to :user
      should_respond_with :success
      should_render_template :show
    end
  
  end
  
  context "when trying to edit a user" do
    
    setup do
      @user = users(:foo)
    end
    
    context "when not logged in" do
      
      setup do
        get :edit, {:id => @user.id}, nil
      end
      
      should_assign_to :user
      should_respond_with :redirect
      should_redirect_to('login path'){ login_path }
      
    end
    
    context "when logged in as the user" do
      
      setup do
        get :edit, {:id => @user.id}, {:user_id => @user.id}
      end
      
      should_assign_to :user
      should_respond_with :success
      should_render_template :edit
      
    end
    
    context "when logged in as someone else" do
      
      setup do
        get :edit, {:id => @user.id}, {:user_id => users(:bar).id}
      end
      
      should_assign_to :user
      should_respond_with :redirect
      should_redirect_to('login path'){ login_path }
      
    end
  
  end
  
end
