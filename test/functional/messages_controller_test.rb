require 'test_helper'

class MessagesControllerTest < ActionController::TestCase

  context "creating a message" do
    
    setup do
      @user = users(:foo)
      Message.destroy_all
    end
    
    context "when not logged in" do
      setup do
        Message.any_instance.stubs(:valid?).returns(true)
        post(:create)
      end
      should_respond_with :redirect
      should_redirect_to('login path'){ login_path }
    end
    
    context "when logged in" do
      
      context "with valid params" do
        setup do
          good_params = {:message => {
                         :body => Faker::Lorem.sentence}}
          post :create, good_params, {:user_id => users(:foo)}
        end
        should " increment the number of messages" do
          assert 1, Message.count
        end
        should_redirect_to('root path'){ root_url }
      end
      
      context "with invalid params" do
        setup do
          bad_params = {:message =>{
                        :body    => Faker::Lorem.paragraphs(2).to_s }}
          post :create, bad_params, {:user_id => users(:foo)}
        end
        should "not increment the number of messages" do
          assert 0, Message.count
        end
        should_redirect_to('root path'){ root_url }
      end
      
    end
    
  end
end
