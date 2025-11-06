# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'faker'

Event.find_or_create_by(name: DateTime.now.year.to_s)

USR = "admin@domain.com"
PWD = "changeme"

User.find_or_create_by(email: USR) do |u|
  u.name = "Administrator"
  u.lastname = "Account"
  u.nick = "Admin"
  u.dob = (DateTime.now - 20.years)
  u.is_male = true
  u.password = PWD
  u.phone = "1234567890"
  u.country = "Mexico"
  u.state = "Jalisco"
  u.city = "Guadalajara"
  u.is_admin = true
  u.guest_history = []
end
puts "Admin user ensured. Login using: #{USR}/#{PWD}"

Faker::Config.locale = 'es'
count = ENV.fetch("USERS", 50).to_i
created = 0

def add_guests(user)
  guest_count = rand(0..10)
  guest_count.times do
    is_male = [true, false].sample

    user.registries.first.guests.create(
      name: Faker::Name.first_name,
      lastname: Faker::Name.last_name,
      nick: Faker::Internet.username,
      is_male: is_male,
      age: Faker::Number.between(from: 0, to: 100),
      relation: Guest.relations.keys.sample,
      is_pregnant: is_male ? false : [true, false].sample,
      is_medicated: [true, false].sample,
      **random_services
    )
  end
end

def random_services
  {
    f_v1: [true, false].sample,
    f_v2: [true, false].sample,
    f_v3: [true, false].sample,
    f_s1: [true, false].sample,
    f_s2: [true, false].sample,
    f_s3: [true, false].sample,
    f_d1: [true, false].sample,
    f_d2: [true, false].sample,
    f_d3: [true, false].sample,
    f_l1: [true, false].sample,
    f_l2: [true, false].sample,
    f_l3: [true, false].sample,
    t_v1: [true, false].sample,
    t_v2: [true, false].sample,
    t_s1: [true, false].sample,
    t_s2: [true, false].sample,
    t_d1: [true, false].sample,
    t_d2: [true, false].sample,
    t_l1: [true, false].sample,
    t_l2: [true, false].sample,
    l_v: [true, false].sample,
    l_s: [true, false].sample,
    l_d: [true, false].sample,
    l_l: [true, false].sample
  }
end


count.times do
  print '.'
  name = Faker::Name.first_name
  lastname = Faker::Name.last_name
  nick = Faker::Internet.username
  username = Faker::Internet.unique.username(specifier: "#{name} #{lastname}", separators: %w(. _ -))
  email_nick = I18n.transliterate(username).gsub(/[^A-Za-z0-9._-]/, '')
  email = Faker::Internet.unique.email(name: email_nick, separators: %w(. _ -))
  dob = Faker::Date.birthday(min_age: 18, max_age: 100)
  is_male = [true, false].sample
  phone = Faker::Number.number(digits: 10) # Faker::PhoneNumber.cell_phone
  country = Faker::Address.country_code
  state = Faker::Address.state_abbr
  city = Faker::Address.city

  user = User.find_or_initialize_by(email: email)
  next if user.persisted?

  user.assign_attributes(
    name: name,
    lastname: lastname,
    nick: nick,
    dob: dob,
    is_male: is_male,
    password: PWD,
    phone: phone,
    country: country,
    state: state,
    city: city,
    is_admin: false,
    guest_history: []
  )
  if user.save
    created += 1
    user.registries.first.guests.me.update(random_services)
    user.registries.first.update(amount_offering: rand(0..5000), comments: Faker::Lorem.sentence(word_count: rand(0..10)))
    add_guests(user)
  else
    puts "Failed to create user #{email}: #{user.errors.full_messages.join(', ')}"
  end
end
puts "\nCreated #{created} users."
