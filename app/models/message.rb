class Message < ActiveRecord::Base
  
  attr_accessible :body
  
  belongs_to :user
  belongs_to :recipient, :class_name => "User"
  
  validates_presence_of :user, :body
  validates_length_of :body, :maximum => 140
  
  before_save :check_for_recipient
  
private

  def check_for_recipient
    recipient_username = self.body.match(/^@([-\w\._@]+)/)[1]
    unless recipient_username.blank?
      self.recipient = User.find_by_username(recipient_username)
    end
  end
  
end
