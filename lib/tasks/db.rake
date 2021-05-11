# frozen_string_literal: true

namespace :db do
  desc "fill database with Fake data"
  task populate: [:environment] do
    raise "You cannot run this in production" if Rails.env.production?

    require "faker"
    include Faker

    # Rake::Task['db:reset'].invoke

    puts "Creating 20 users..."
    20.times do
      user = User.new do |u|
        password = Internet.password 6, 12
        u.name = Name.first_name
        u.lastname = Name.last_name
        u.nick = password
        u.is_male = Boolean.boolean
        u.email = Internet.email
        u.phone = Number.number 10 # PhoneNumber.phone_number
        u.country = Address.country
        u.state = Address.state
        u.city = Address.city
        u.password = password
        u.password_confirmation = password
        u.dob = Faker::Date.birthday 18, 99
      end

      reg = Registry.new
      reg.event = Event.current
      reg.comments = Boolean.boolean(0.2) ? Lorem.paragraph : nil
      reg.amount_offering = Boolean.boolean(0.4) ? Number.between(0, 9999) : 0

      user.registries << reg
      user.save
      puts "  #{user.id} -> Age: #{user.age}, Sex: #{user.is_male ? "M" : "F"}, Name: #{user.full_name false}"
    end
  end
end
