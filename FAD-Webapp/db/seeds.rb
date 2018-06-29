# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Restaurant.delete_all

Restaurant.create!(name: "Hamilton Royal India Grill", address: "6 Broad Street, Hamilton, NY 13346", url:"http://hamiltonroyalindiagrill.com/contact/", cuisine: "Indian")
Restaurant.create!(name: "N13", address: "3 Lebanon St, Hamilton, NY 13346", url: "http://www.noodles13.com/", cuisine: "Asian")
Restaurant.create!(name: "La Iguana", address: "10 BROAD STREET, HAMILTON, NY 13346", url: "http://www.laiguanarestaurant.com/", cuisine: "Mexican")
Restaurant.create!(name: "Colgate Inn", address: "1 Payne Street, Hamilton, New York 13346",url: "https://www.colgateinn.com/", cuisine: "American")
