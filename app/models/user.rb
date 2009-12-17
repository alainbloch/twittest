class User < ActiveRecord::Base
  # new columns need to be added here to be writable through mass assignment
  attr_accessible :username, :email, :password, :password_confirmation, :full_name, :bio, :avatar
  
  attr_accessor :password
  before_save :prepare_password
  
  validates_presence_of :username, :full_name
  validates_uniqueness_of :username, :email, :allow_blank => true
  validates_format_of :username, :with => /^[-\w\._]+$/i, :allow_blank => true, :message => "should only contain letters, numbers, or .-_"
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 4, :allow_blank => true
  validates_length_of :full_name, :maximum => 40
  validates_length_of :bio, :maximum => 160, :allow_blank => true
    
  # users who the user follows
  has_many :follows, :class_name => "Following", :foreign_key => "follower_id", :dependent => :destroy
  has_many :users_followed, :through => :follows, :source => :user
  
  # users who are following the user
  has_many :followings
  has_many :followers, :through => :followings
  
  has_many :messages, :dependent => :destroy
  
  html_sanitizer :sanitize => [:full_name, :bio]
  
  has_attached_file :avatar, :styles => {:normal => "533x400#",
                                         :thumbnail    => '72>',
                                         :icon => '36x36>' }
  
  # login can be either username or email address
  def self.authenticate(login, pass)
    user = find_by_username(login) || find_by_email(login)
    return user if user && user.matching_password?(pass)
  end
  
  def matching_password?(pass)
    self.password_hash == encrypt_password(pass)
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
  
  def main_photo
    avatar.exists? ? avatar.url(:original) : "default.png" 
  end

  def thumbnail
    avatar.exists? ? avatar.url(:thumbnail) : "default_thumbnail.png"
  end

  def icon    
    avatar.exists? ? avatar.url(:icon) : "default_icon.png" 
  end
  
  private
  
  def prepare_password
    unless password.blank?
      self.password_salt = Digest::SHA1.hexdigest([Time.now, rand].join)
      self.password_hash = encrypt_password(password)
    end
  end
  
  def encrypt_password(pass)
    Digest::SHA1.hexdigest([pass, password_salt].join)
  end
end
