# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin = User.create name: 'Administrator',
                    lastname: 'Account',
                    nick: 'Admin',
                    dob: DateTime.new(1980, DateTime.now.month, DateTime.now.day),
                    is_male: true,
                    email: 'admin@domain.com',
                    phone: '1234567890',
                    country: 'MX',
                    state: 'ST',
                    city: 'City',
                    password: 'changeme',
                    is_admin: true
admin.save

Event.find_or_create_by(name: Time.current.year.to_s)