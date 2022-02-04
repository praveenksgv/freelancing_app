# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)




# Create a main sample user.
User.create!(name:  "Praveen Sharma",
             email: "praveenjdh2018@gmail.com",
             password:              "12345678",
             password_confirmation: "12345678",
             role: 1,
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name:  "Arpit Goyal",
             email: "arpit@gmail.com",
             password:              "12345678",
             password_confirmation: "12345678",
             role: 0,
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

# Generate a bunch of additional users.
49.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+50}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               role: 1,
               activated: true,
               activated_at: Time.zone.now)
end
49.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               role: 0,
               activated: true,
               activated_at: Time.zone.now)
end

# users = User.order(:created_at).take(6)
# 50.times do
#   content = Faker::Lorem.sentence(word_count: 5)
#   users.each {|user| user.microposts.create!(content: content)}
# end

clients = User.where("role = 0")
10.times do 
  t = Faker::Lorem.sentence(word_count: 5)
  d = Faker::Lorem.sentence(word_count: 30)
  s = "Machine Learning , Web development"
  clients.each {|user| user.jobs.create!(title: t, description: d, budget: 10,skills: s, state: 2)}
end


# Create following relationships.
# users = User.all
# user  = users.first
# following = users[2..50]
# followers = users[3..40]
# following.each { |followed| user.follow(followed) }
# followers.each { |follower| follower.follow(user) }