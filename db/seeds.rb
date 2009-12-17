# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

require 'faker'
require 'populator'

# Need to make sure we don't add extra Users
User.destroy_all

# Adding Users
100.times do
  name = Faker::Name.first_name
  User.create(:username  => name.downcase,
              :email     => Faker::Internet.email,
              :full_name => name,
              :password  => "secret",
              :password_confirmation => "secret",
              :bio => Faker::Lorem.sentence)
end

User.all.each do |user|

  # Adding Messages
  Message.populate(5..10) do |message|
    message.body = Faker::Lorem.sentence 
    message.user_id = user.id
  end
  
  # Adding Followings
  rand(10).times do
    user.followings.create(:follower => User.all[rand(User.count)])
  end

end