require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  it "should be able to create a Restaurant object which has the correct methods on it" do
    r = Restaurant.create!(name: "Hamilton Royal India Grill", url: "http://hamiltonroyalindiagrill.com/", address: "6 Broad Street Hamilton, NY 13346" , cuisine: "Indian")
    expect(r).to respond_to(:name)
    expect(r).to respond_to(:url)
    expect(r).to respond_to(:cuisine)
    expect(Restaurant).to respond_to(:filter_on_constraints)
  end


  it "should fail to create a Restaurant object if no name is specified" do
    expect{Restaurant.create!(url: "http://hamiltonroyalindiagrill.com/", address: "6 Broad Street Hamilton, NY 13346" , cuisine: "Indian")}.to raise_exception(ActiveRecord::NotNullViolation)
    expect{Restaurant.create!(address: "6 Broad Street Hamilton, NY 13346" , cuisine: "Indian")}.to raise_exception(ActiveRecord::NotNullViolation)
  end

  it "should have many foods" do
    assoc = Restaurant.reflect_on_association(:foods)
    expect(assoc.macro).to eq(:has_many)
  end

  describe "filter_on_constraints test" do

    before(:example) do
      Restaurant.create!(name: "Hamilton Royal India Grill", url: "http://hamiltonroyalindiagrill.com/", address: "6 Broad Street Hamilton, NY 13346" , cuisine: "Indian")
      Restaurant.create!(name: "Another Indian Restaurant", address: "Hamilton, NY", cuisine: "Indian")
      Restaurant.create!(name: "La Iguana", url: "http://www.laiguanarestaurant.com/", address: "10 Broad St, Hamilton, NY 13346" , cuisine: "Mexican")
      Restaurant.create!(name: "N13", url: "http://www.noodles13.com/", address: "3 Lebanon St, Hamilton, NY 13346" , cuisine: "Asian")
    end

    it "should filter correctly for names" do
      q = Restaurant.filter_on_constraints(name: "La Iguana")
      expect(q.length).to eq(1)
      q = Restaurant.filter_on_constraints(name: "N13")
      expect(q.length).to eq(1)
    end

    it "should filter correctly for cuisines" do
      q = Restaurant.filter_on_constraints(cuisine: "Indian")
      expect(q.length).to eq(2)
      q = Restaurant.filter_on_constraints(cuisine: "Asian")
      expect(q.length).to eq(1)
    end

    it "should filter correctly with multiple constraints" do
      q = Restaurant.filter_on_constraints(url: "http://www.noodles13.com/", cuisine: "Asian")
      expect(q.length).to eq(1)
      q = Restaurant.filter_on_constraints(address: "Hamilton, NY", cuisine: "Indian")
      expect(q.length).to eq(1)
    end

    it "should ignore invalid constraints" do
      q = Restaurant.filter_on_constraints(title: "Another Indian Restaurant", cuisine: "Asian")
      expect(q.length).to eq(1)
    end

  end

  describe "query_on_constraints test" do
    before(:example) do
      rig = Restaurant.create!(name: "Hamilton Royal India Grill", url: "http://hamiltonroyalindiagrill.com/", address: "6 Broad Street Hamilton, NY 13346" , cuisine: "Indian")
      rig.foods << Food.create!(name: "Chicken Tikka Masala", description: "Tender pieces of white meat chicken cooked in a mildly tomato sauce.", contains_other: "chicken", contains_dairy: true)
      rig.foods << Food.create!(name: "Veg Pakora", description: "Fresh vegetable dipped in spices batter and fried to golden perfection.", contains_gluten: true, contains_wheat: true, contains_other: "carrots")
      mex = Restaurant.create!(name: "La Iguana", url: "http://www.laiguanarestaurant.com/", address: "10 Broad St, Hamilton, NY 13346" , cuisine: "Mexican")
      mex.foods << Food.create!(name: "NACHOS GRANDES", description: "A mound of our homemade tortilla chips topped with choice of beans (black or refried), melted cheddar and Monterey Jack cheese, pickled jalapeno, homemade guacamole, and sour cream Picadillo beef,Veggie (Corn & Zucchini) or Grilled Southwest Chicken, our homemade guacamole, and sour cream.", contains_gluten: true, contains_beef: true, contains_wheat: true, contains_other: "chicken")
      mex.foods << Food.create!(name: "SALMON RANCHERO", description: "Blackened broiled salmon served with rice, corn & zucchini and ranchero sauce.", contains_fish: true)
      Restaurant.create!(name: "N13", url: "http://www.noodles13.com/", address: "3 Lebanon St, Hamilton, NY 13346" , cuisine: "Asian")
      Restaurant.create!(name: "Another Indian Restaurant", address: "Hamilton, NY", cuisine: "Indian")
    end

    it "should filter correctly for names" do
      q = Restaurant.query_on_constraints(query_type: "name", query: "Hamilton Royal India Grill")
      expect(q.length).to eq(1)
      q = Restaurant.query_on_constraints(query_type: "name", query: "La Iguana")
      expect(q.length).to eq(1)
      q = Restaurant.query_on_constraints(query_type: "name", query: "Colgate Inn")
      expect(q.length). to eq(0)
    end

    it "should filter correctly for urls" do
      q = Restaurant.query_on_constraints(query_type: "url", query: "http://hamiltonroyalindiagrill.com/")
      expect(q.length).to eq(1)
      q = Restaurant.query_on_constraints(query_type: "url", query: "http://www.noodles13.com/")
      expect(q.length).to eq(1)
      q = Restaurant.query_on_constraints(query_type: "url", query: "http://www.youtube.com/")
      expect(q.length).to eq(0)
    end

    it "should filter correctly without a name or url" do
      q = Restaurant.query_on_constraints(query_type: "name", query: "", dairy: true)
      expect(q.length).to eq(0)
      q = Restaurant.query_on_constraints(query_type: "url", query: "", gluten: true)
      expect(q.length).to eq(0)
    end

    it "should filter correctly with a single allergen" do
      q = Restaurant.query_on_constraints(query_type: "name", query: "La Iguana", gluten: true)
      expect(q.length).to eq(1)
      q = Restaurant.query_on_constraints(query_type: "url", query: "http://www.laiguanarestaurant.com/", pork: true)
      expect(q.length).to eq(1)
    end

  end

end
# $ rails db:drop
# $ rails db:migrate
# $ rails db:test:prepare
# $ rails db:seed
