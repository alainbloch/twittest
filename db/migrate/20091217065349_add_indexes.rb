class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index "users", ["username"]
    add_index "messages", ["user_id"]
    add_index "messages", ["recipient_id"]
    add_index "followings", ["follower_id", "user_id"]
  end

  def self.down
  end
end
