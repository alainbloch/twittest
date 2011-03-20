class CreateUsersAndSessions < ActiveRecord::Migration
  def self.up
    
    create_table :users, :force => true do |t|
      t.string   :name
      t.string   :email
      t.string   :fullname
      t.string   :crypted_password,                 :null => false
      t.string   :password_salt,                    :null => false
      t.string   :persistence_token,                :null => false
      t.integer  :login_count,       :default => 0, :null => false
      t.datetime :last_request_at
      t.datetime :last_login_at
      t.datetime :current_login_at
      t.string   :last_login_ip
      t.string   :current_login_ip
      t.datetime :created_at
      t.datetime :updated_at
      t.text     :bio
    end
    
    create_table :sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps
    end

    add_index :sessions, :session_id
    add_index :sessions, :updated_at
    
  end
  
  def self.down
    drop_table :users
  end
end
