require 'rails_helper'
describe "show page", type: :feature do
  before :each do
    Restaurant.create!(name: "Hamilton Royal India Grill", address: "6 Broad Street, Hamilton, NY 13346", url:"http://hamiltonroyalindiagrill.com/contact/", cuisine: "Indian", description:"Royal India Grill Cuisine is prepared fresh, paying careful attention to our patron’s choice of mild, medium or hot flavor. We do not use packaged curry powders or canned meat, seafood or vegetables. Every dish at Royal India Grill is prepared according to original recipes, which have become part of Indian culture over thousands of years. We are confident that your dining experience at Royal India Grill will be a pleasant one!")
    Restaurant.create!(name: "La Iguana", address: "10 BROAD STREET, HAMILTON, NY 13346", url: "http://www.laiguanarestaurant.com/", cuisine: "Mexican", description: "An energetic Mexican restaurant with dishes based on authentic foods but inauthentic prices and customers.")
    visit "/restaurants"
  end
  it "should have links to create a new restaurant" do
    expect(page).to have_link("New Restaurant")
  end
  it "should have a link to go back to the restaurants home page" do
   expect(page).to have_link("Back to homepage")
 end
 it "clicking different allergens and putting a restaurant name should display food details for that restaurant" do
   page.check('gluten')
   click_button('submit')
   click_link("Hamilton Royal India Grill")
   expect(page).to have_link("Back")
 end
end
