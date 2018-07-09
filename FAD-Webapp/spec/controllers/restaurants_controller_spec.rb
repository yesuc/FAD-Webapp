require 'rails_helper'

RSpec.describe RestaurantsController, type: :controller do
  describe "GET #new" do
   it "returns http success" do
     get :new
     expect(response).to have_http_status(:success)
   end
 end

 describe "GET #create" do
   it "returns http success" do
     get :create, params: {:restaurant => {name: "La Iguana", url: "http://www.laiguanarestaurant.com/", address: "10 Broad St, Hamilton, NY 13346" , cuisine: "Mexican"}}
     expect(response).to have_http_status(:redirect)
   end
 end

 describe "GET #index" do
     it "returns http success" do
       get :index
       expect(response).to have_http_status(:success)
     end
   end

   describe "GET #edit" do
      it "returns http success" do
        Restaurant.create!(name: "La Iguana", url: "http://www.laiguanarestaurant.com/", address: "10 Broad St, Hamilton, NY 13346" , cuisine: "Mexican")
        get :edit, params: {:id => 1, :restaurant => {name: "New Mexican Place in Town", url: "http://www.laiguanarestaurant.com/", address: "10 Broad St, Hamilton, NY 13346" , cuisine: "Mexican"}}
        expect(response).to have_http_status(:success)
      end
    end
  describe "GET #show" do
     it "returns http success" do
       Restaurant.create!(name: "La Iguana", url: "http://www.laiguanarestaurant.com/", address: "10 Broad St, Hamilton, NY 13346" , cuisine: "Mexican")
       get :search, params: {:query => "La Iguana", :query_type => "name"} ,session:{ :gluten => "on" }
       expect(request.session[:gluten]).to eq "on"
       expect(response).to have_http_status(:success)
     end
   end

 describe "GET #update" do
    it "returns http success" do
      Restaurant.create!(name: "La Iguana", url: "http://www.laiguanarestaurant.com/", address: "10 Broad St, Hamilton, NY 13346" , cuisine: "Mexican")
      get :update, params: {:id => 1, :restaurant => {name: "New Mexican Place in Town", url: "http://www.laiguanarestaurant.com/", address: "10 Broad St, Hamilton, NY 13346" , cuisine: "Mexican"}}
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET #show" do
     it "returns http success" do
       Restaurant.create!(name: "La Iguana", url: "http://www.laiguanarestaurant.com/", address: "10 Broad St, Hamilton, NY 13346" , cuisine: "Mexican")
       get :show, params: {:id => 1, :restaurant => {name: "La Iguana", url: "http://www.laiguanarestaurant.com/", address: "10 Broad St, Hamilton, NY 13346" , cuisine: "Mexican"}}
       expect(response).to have_http_status(:success)
     end
   end

 describe "GET #destroy" do
    it "returns http success" do
      Restaurant.create!(name: "La Iguana", url: "http://www.laiguanarestaurant.com/", address: "10 Broad St, Hamilton, NY 13346" , cuisine: "Mexican")
      get :destroy, params: {:id => 1, :restaurant => {name: "New Mexican Place in Town", url: "http://www.laiguanarestaurant.com/", address: "10 Broad St, Hamilton, NY 13346" , cuisine: "Mexican"}}
      expect(response).to redirect_to(restaurants_path)
    end
  end
describe "bad paths for create/update" do
    it "should redirect to new on create failure" do
      p =  Restaurant.new(name: "La Iguana", url: "http://www.laiguanarestaurant.com/", address: "10 Broad St, Hamilton, NY 13346" , cuisine: "Mexican")
      expect(Restaurant).to receive(:new) { p }
      expect(p).to receive(:save) { nil }
      post :create, params: {:restaurant => { name: "La Iguana", url: "http://www.laiguanarestaurant.com/", address: "10 Broad St, Hamilton, NY 13346" , cuisine: "Mexican"}}
      expect(response).to redirect_to(new_restaurant_path)
    end
  it "should redirect to show on update failure" do
    p =  Restaurant.create!(name: "La Iguana", url: "http://www.laiguanarestaurant.com/", address: "10 Broad St, Hamilton, NY 13346" , cuisine: "Mexican")
    expect(Restaurant).to receive(:find) { p }
    expect(p).to receive(:update) {p}
    expect(p).to receive(:save) { nil }
    post :update,params: {:id => 1, :restaurant => {name: "New Mexican Place in Town", url: "http://www.laiguanarestaurant.com/", address: "10 Broad St, Hamilton, NY 13346" , cuisine: "Mexican"}}
    expect(response).to redirect_to(edit_restaurant_path(p))
   end
 end

end
