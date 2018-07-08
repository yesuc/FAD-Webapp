require 'rails_helper'

RSpec.describe Food, type: :model do
  it "should be able to create a Food object which has the correct methods on it" do
    f = Food.create!(name: "Veg Pakora", description: "Potatoes fried in chickpea flour", contains_soy: nil, contains_egg: nil, contains_fish: nil, contains_sesame: nil, contains_shellfish: nil, contains_dairy: nil, contains_beef: nil,contains_pork: nil, contains_wheat: nil, contains_peanut: nil, contains_treenuts: nil, contains_other: "", contains_gluten: nil)
    expect(f).to respond_to(:name)
    expect(f).to respond_to(:description)
    expect(f).to respond_to(:contains_soy)
    expect(f).to respond_to(:contains_sesame)
    expect(f).to respond_to(:contains_shellfish)
    expect(f).to respond_to(:contains_fish)
    expect(f).to respond_to(:contains_dairy)
    expect(f).to respond_to(:contains_gluten)
    expect(f).to respond_to(:contains_wheat)
    expect(f).to respond_to(:contains_treenuts)
    expect(f).to respond_to(:contains_peanut)
    expect(f).to respond_to(:contains_egg)
    expect(f).to respond_to(:contains_pork)
    expect(f).to respond_to(:contains_beef)
    expect(f).to respond_to(:contains_other)

  end
  it "should fail to create a Food object if no name is specified" do
    expect{Food.create!(description: "Potatoes fried in chickpea flour")}.to raise_exception(ActiveRecord::NotNullViolation)
    expect{Food.create!(description: "Potatoes fried in chickpea flour")}.to raise_exception(ActiveRecord::NotNullViolation)
  end

  it "should belong to a restaurant" do
    assoc = Food.reflect_on_association(:restaurant)
    expect(assoc.macro).to eq(:belongs_to)
  end

  it "should check for input allergen using the food item name" do
    f = Food.create!(name: "Puri bread", description: "", contains_gluten: true, contains_wheat: true)
    q = Food.check_restrictions(f.name.split(), :gluten)
    expect(q).to eq(true)
  end

  it "should check for input allergen using the food description" do
    f = Food.create!(name: "Puri bread", description: "contains wheat flour", contains_gluten: true, contains_wheat: true)
    q = Food.check_restrictions(f.description.split(), :gluten)
    expect(q).to eq(true)
  end
  it "should return false if no allergen is found in the food name" do
    f = Food.create!(name: "Garden Salad", description: "contains greens", contains_gluten: false, contains_wheat: false)
    q = Food.check_restrictions(f.description.split(), :gluten)
    expect(q).to eq(false)
  end
  describe "get_menu_and_food_ingredients test" do

    it "should scrape the menu from a given restaurant url" do
      r = Restaurant.create!(name: "La Iguana", url: "http://www.laiguanarestaurant.com/", address: "10 Broad St, Hamilton, NY 13346" , cuisine: "Mexican")
      r.foods << Food.create!(name: "NACHOS GRANDES", description: "A mound of our homemade tortilla chips topped with choice of beans (black or refried), melted cheddar and Monterey Jack cheese, pickled jalapeno, homemade guacamole, and sour cream Picadillo beef,Veggie (Corn & Zucchini) or Grilled Southwest Chicken, our homemade guacamole, and sour cream.", contains_gluten: true, contains_beef: true, contains_wheat: true, contains_other: "chicken", contains_dairy: true)
      r.foods << Food.create!(name: "SALMON RANCHERO", description: "Blackened broiled salmon served with rice, corn & zucchini and ranchero sauce.", contains_fish: true)
      q = r.foods
      expect(q.length).to eq(2)
    end
    it "should return foods fitting the food restriction- dairy" do
      r = Restaurant.create!(name: "La Iguana", url: "http://www.laiguanarestaurant.com/", address: "10 Broad St, Hamilton, NY 13346" , cuisine: "Mexican")
      r.foods << Food.create!(name: "NACHOS GRANDES", description: "A mound of our homemade tortilla chips topped with choice of beans (black or refried), melted cheddar and Monterey Jack cheese, pickled jalapeno, homemade guacamole, and sour cream Picadillo beef,Veggie (Corn & Zucchini) or Grilled Southwest Chicken, our homemade guacamole, and sour cream.", contains_gluten: true, contains_beef: true, contains_wheat: true, contains_other: "chicken", contains_dairy: true)
      r.foods << Food.create!(name: "SALMON RANCHERO", description: "Blackened broiled salmon served with rice, corn & zucchini and ranchero sauce.", contains_fish: true, contains_dairy: false)
      q = r.foods.dairy_free
      expect(q.length).to eq(1)
    end
    it "should return foods fitting the food restriction - gluten"do
      r = Restaurant.create!(name: "La Iguana", url: "http://www.laiguanarestaurant.com/", address: "10 Broad St, Hamilton, NY 13346" , cuisine: "Mexican")
      r.foods << Food.create!(name: "NACHOS GRANDES", description: "A mound of our homemade tortilla chips topped with choice of beans (black or refried), melted cheddar and Monterey Jack cheese, pickled jalapeno, homemade guacamole, and sour cream Picadillo beef,Veggie (Corn & Zucchini) or Grilled Southwest Chicken, our homemade guacamole, and sour cream.", contains_gluten: true, contains_beef: true, contains_wheat: true, contains_other: "chicken", contains_dairy: true)
      r.foods << Food.create!(name: "SALMON RANCHERO", description: "Blackened broiled salmon served with rice, corn & zucchini and ranchero sauce.", contains_fish: true, contains_gluten: false)
      q = r.foods.gluten_free
      expect(q.length).to eq(1)
    end
    it "should return foods fitting the food restriction - wheat"do
      r = Restaurant.create!(name: "La Iguana", url: "http://www.laiguanarestaurant.com/", address: "10 Broad St, Hamilton, NY 13346" , cuisine: "Mexican")
      r.foods << Food.create!(name: "NACHOS GRANDES", description: "A mound of our homemade tortilla chips topped with choice of beans (black or refried), melted cheddar and Monterey Jack cheese, pickled jalapeno, homemade guacamole, and sour cream Picadillo beef,Veggie (Corn & Zucchini) or Grilled Southwest Chicken, our homemade guacamole, and sour cream.", contains_gluten: true, contains_beef: true, contains_wheat: true, contains_other: "chicken", contains_dairy: true)
      r.foods << Food.create!(name: "SALMON RANCHERO", description: "Blackened broiled salmon served with rice, corn & zucchini and ranchero sauce.", contains_fish: true, contains_gluten: false, contains_wheat: false)
      q = r.foods.wheat_free
      expect(q.length).to eq(1)
    end
    it "should return foods fitting the food restriction - gluten"do
      r = Restaurant.create!(name: "La Iguana", url: "http://www.laiguanarestaurant.com/", address: "10 Broad St, Hamilton, NY 13346" , cuisine: "Mexican")
      r.foods << Food.create!(name: "NACHOS GRANDES", description: "A mound of our homemade tortilla chips topped with choice of beans (black or refried), melted cheddar and Monterey Jack cheese, pickled jalapeno, homemade guacamole, and sour cream Picadillo beef,Veggie (Corn & Zucchini) or Grilled Southwest Chicken, our homemade guacamole, and sour cream.", contains_gluten: true, contains_beef: true, contains_wheat: true, contains_fish: false, contains_other: "chicken", contains_dairy: true)
      r.foods << Food.create!(name: "SALMON RANCHERO", description: "Blackened broiled salmon served with rice, corn & zucchini and ranchero sauce.", contains_fish: true, contains_gluten: false)
      q = r.foods.fish_free
      expect(q.length).to eq(1)
    end


  end

end
# $ rails db:drop
# $ rails db:migrate
# $ rails db:test:prepare
# $ rails db:seed
