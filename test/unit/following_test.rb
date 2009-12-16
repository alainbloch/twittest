require 'test_helper'

class FollowingTest < ActiveSupport::TestCase
  
  def new_following(attributes = {})
    @user1 = users(:foo)
    @user2 = users(:bar)
    attributes[:follower_id] ||= @user1.id
    attributes[:user_id] ||= @user2.id
    following =  Following.new(attributes)
    following.valid?
    following
   end

  context "A Following" do
  
    setup do
      Following.delete_all
    end
    
    should_belong_to :follower
    should_belong_to :user
      
    should "need to have an associated user" do
      assert new_following(:user_id => "").errors.on(:user)
    end

    should "need to have an associated follower" do
      assert new_following(:follower_id => "").errors.on(:follower)
    end

    should "not be able to have a user follow the same person more than once" do
      new_following.save!
      assert new_following.errors.on(:follower_id)
    end

    context "when its created" do
      setup do
        @following = new_following
        @following.save!
      end
      
      should "have an associated user" do
        assert_not_nil @following.user
      end

      should "have an associated follower" do
        assert_not_nil @following.follower
      end

    end
        
  end

end
