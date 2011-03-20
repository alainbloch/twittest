class CreateFollowings < ActiveRecord::Migration
  def self.up
    create_table :followings do |t|
      t.integer :user_id, :follower_id
      t.timestamps
    end
  end

  def self.down
    drop_table :followings
  end
end