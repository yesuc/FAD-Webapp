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

end
# $ rails db:drop
# $ rails db:migrate
# $ rails db:test:prepare
# $ rails db:seed
