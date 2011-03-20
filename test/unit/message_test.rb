require 'test_helper'

class MessageTest < ActiveSupport::TestCase

  def new_message(attributes = {})
    attributes[:body] ||= Faker::Lorem.sentence
    attributes[:user_id] ||= users(:foo).id
    message = Message.new(attributes)
    message.user_id = attributes[:user_id]
    message.valid?
    message
  end

  context "a Message instance" do
    should_belong_to :user, :recipient
    should_not_allow_mass_assignment_of :recipient_id, :user_id
  end
  
  context "a new Message" do
    
    should "be valid with valid attributes" do
      assert new_message.valid?
    end
    
    should "require a user" do
      assert new_message(:user_id => 0).errors.on(:user)
    end
    
    should "require a body" do
      assert new_message(:body => "").errors.on(:body)
    end
    
    should "not have a body over 140 characters" do
      assert new_message(:body => Faker::Lorem.paragraphs(2).to_s).errors.on(:body)
    end
    
    should "send the message to a recipient if the body is prepended with @name" do
      user = users(:bar)
      message = new_message(:body => "@#{user.name} how ya doing?")
      message.save
      assert message.recipient, user
    end
    
  end
  
end
