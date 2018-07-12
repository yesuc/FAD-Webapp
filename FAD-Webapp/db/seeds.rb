# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Restaurant.delete_all

Restaurant.create!(name: "Hamilton Royal India Grill", address: "6 Broad Street, Hamilton, NY 13346", url:"http://hamiltonroyalindiagrill.com/contact/", cuisine: "Indian", description:"Royal India Grill Cuisine is prepared fresh, paying careful attention to our patron’s choice of mild, medium or hot flavor. We do not use packaged curry powders or canned meat, seafood or vegetables. Every dish at Royal India Grill is prepared according to original recipes, which have become part of Indian culture over thousands of years. We are confident that your dining experience at Royal India Grill will be a pleasant one!")
Restaurant.create!(name: "N13", address: "3 Lebanon St, Hamilton, NY 13346", url: "http://www.noodles13.com/", cuisine: "Asian", description:"Embracing the great comfort foods of Vietnam, Thailand, Korea, and China, we offer a culinary tour with a contemporary flair; and a focus on value and quality demanded by a vibrant college town market.")
Restaurant.create!(name: "La Iguana", address: "10 BROAD STREET, HAMILTON, NY 13346", url: "http://www.laiguanarestaurant.com/", cuisine: "Mexican", description: "An energetic Mexican restaurant with dishes based on authentic foods but inauthentic prices and customers.")
