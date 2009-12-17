require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  context "home index" do
    
    context "when logged in" do
      setup do
        post :index, {}, {:user_id => users(:foo).id}
      end
      should_assign_to :messages
      should_render_template :dashboard
    end
    
    context "when not logged in" do
      setup do
        post :index
      end
      should_assign_to :messages
      should_render_template :index            
    end
    
  end
  
end
