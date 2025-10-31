# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Event.find_or_create_by(name: DateTime.now.year.to_s)

USER = "admin@domain.com"
PASS = "changeme"

User.create(name: "Administrator",
            lastname: "Account",
            nick: "Admin",
            dob: (DateTime.now - 20.years),
            is_male: true,
            email: USER,
            password: PASS,
            phone: "1234567890",
            country: "MX",
            state: "ST",
            city: "City",
            is_admin: true,
            guest_history: [])

puts "Admin user created. Login using: #{USER}/#{PASS}"
