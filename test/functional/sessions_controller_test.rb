require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  
  should "have a new session page" do
    get :new
    assert_template 'new'
  end
  
  should "not create a session if invalid authentication" do
    User.stubs(:authenticate).returns(nil)
    post :create
    assert_template 'new'
    assert_nil session['user_id']
  end
  
  should "create a session if valid authentication" do
    User.stubs(:authenticate).returns(User.first)
    post :create
    assert_redirected_to root_url
    assert_equal User.first.id, session['user_id']
  end
  
end
