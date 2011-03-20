class User < ActiveRecord::Base
  
  validates_presence_of :name
  validates_uniqueness_of :name, :email
  validates_format_of :name, :with => /^[-\w\._]+$/i, :message => "should only contain letters, numbers, or .-_"
  validates_length_of :name, :maximum => 40
  validates_length_of :bio, :maximum => 160, :allow_blank => true
    
  # users who the user follows
  has_many :follows, :class_name => "Following", :foreign_key => "follower_id", :dependent => :destroy
  has_many :users_followed, :through => :follows, :source => :user
  
  # users who are following the user
  has_many :followings
  has_many :followers, :through => :followings
  
  has_many :messages, :dependent => :destroy
  
  html_sanitizer :sanitize => [:fullname, :bio]
  
  # Overriding authlogic validations
  acts_as_authentic do |auth|
    auth.require_password_confirmation = false
  end
  
  def follows?(user)
    !self.follows.find_by_user_id(user).nil?
  end
  
  def feed
    user_id_range = (self.users_followed.map(&:id) + [self.id]) 
    Message.find(:all, 
                 :conditions => ["user_id IN (?) OR recipient_id = ?", user_id_range, self.id ], 
                 :order => 'created_at DESC')
  end
  
end
