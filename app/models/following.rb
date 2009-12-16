class Following < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :follower, :class_name => "User"
  
  validates_presence_of :user, :follower
  validates_uniqueness_of :follower_id, :scope => [:user_id]
  
end
