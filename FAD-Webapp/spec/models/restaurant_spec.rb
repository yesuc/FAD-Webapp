require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  it "should be able to create a Restaurant object which has the correct methods on it" do
    r = Restaurant.create!(name: "Hamilton Royal India Grill", url: "http://hamiltonroyalindiagrill.com/", address: "6 Broad Street Hamilton, NY 13346" , cuisine: "Indian")
    expect(r).to respond_to(:name)
    expect(r).to respond_to(:url)
    expect(r).to respond_to(:cuisine)
  end

  it "should fail to create a Restaurant object if no url or name is specified" do
    expect{Restaurant.create!(address: "6 Broad Street Hamilton, NY 13346" , cuisine: "Indian")}.to raise_exception(ActiveRecord::NotNullViolation)
  end

end
# $ rails db:drop
# $ rails db:migrate
# $ rails db:test:prepare
# $ rails db:seed
