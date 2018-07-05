require 'json'
class RestaurantsController < ApplicationController
  # before_action :set_restaurant, only: [:show, :edit, :update, :destroy]

  # GET /restaurants
  def index
    @restaurants = Restaurant.all
  end

  # GET /restaurants/1
  def show
    @restaurant = Restaurant.find(params[:id])
    scrape_menu
    foods = @restaurant.foods
    double_check = easy_check_restrictions(foods, :dairy)
    hard_check_restrictions(double_check, :dairy)
  end

  # GET /restaurants/new
  def new
    @restaurant = Restaurant.new
  end

  # GET /restaurants/1/edit
  def edit
    @restaurant = Restaurant.find(params[:id])
  end

  # POST /restaurants
  def create
    @restaurant = Restaurant.new(create_update_params)
    if @restaurant.save
      scrape_menu
      redirect_to(restaurant_path(@restaurant), flash: {success: "Restaurant was successfully created."}) and return
    else
      redirect_to(new_restaurant_path(@restaurant), flash: {error: "Error creating new restaurant."}) and return
    end
  end
# If a restaurant does not contain a menu:
# Get menu items and descriptions from menu_data.json, create new food items, with name and description
# Runs python script in run_spiders.py which in turn calls menu_spider.py with the restaurant url
#NOTE: scrape_menu is currently called in controller function show since no new restaurants are being created
  def scrape_menu
    if @restaurant.foods.empty?
      @url = @restaurant.url
      python_output = `python /Users/priyadhawka/Desktop/FAD-Webapp/FAD-Webapp/app/controllers/run_spiders.py #{@url}`
      file = File.read('menu_data.json')
      menu_hash = JSON.parse(file)
      @restaurant.menu = menu_hash.values
      @menu = menu_hash.values
        @menu.each do |item|
          item.each do |i|
            @food = Food.create(:name => i[0], :description => i[1])
            @restaurant.foods << @food
          end
      end
    else
      return @restaurant.foods
    end
  end
# Takes a 'list' of food items from a specific restaurant and the dietary restriction (s) from user input
# Returns an array of foods containing the said restriction
# Calls check_restrictions method from Food model to check if food item name and description contains allergen matching food restriction
  def easy_check_restrictions(foods,restriction)
    contains = "contains_"+ restriction.to_s
    contains = contains.to_sym
    double_check = {}
    foods.each do |food|
      food_name = food.name.downcase
      food_description = food.description.downcase
      if Food.check_restrictions(food_description.split(), restriction) || Food.check_restrictions(food_name.split(), restriction)
        food[contains] = true
      else
        double_check[food] = food_name
      end
    end
    return double_check
  end

# Takes list returned by easy_check_restrictions and food restriction
# Sets contains_restriction attribute of food item
#Calls get_ingredients method from food Model which in turn runs a python script, bing.py with user input arguments
  def hard_check_restrictions(double_check, restriction)
    if double_check.empty?
      return
    else
      contains = "contains_"+ restriction.to_s
      double_check_values = double_check.values.to_json
      python_output = `python /Users/priyadhawka/Desktop/FAD-Webapp/FAD-Webapp/app/controllers/webcrawler/webcrawler/spiders/bing.py #{double_check_values}`
      file = File.read('ingredients_data.json')
      ingredients_hash = JSON.parse(file)
      ingredients_hash = ingredients_hash.values
      double_check.keys.each_with_index do |key,index|
        if !ingredients_hash[index].nil?
          key.ingredients = ingredients_hash.to_s.strip().downcase
          if Food.check_restrictions(key.ingredients.split(), restriction)
            key[contains] = true
          else
            key[contains] = false
          end
        end
      end
    end
  end
  # PATCH/PUT /restaurants/1
  def update
    @restaurant = Restaurant.find(params[:id])
    @restaurant.update(create_update_params)
    if @restaurant.save
      redirect_to(restaurant_path(@restaurant), flash: {success: "Restaurant was successfully updated."}) and return
    else
      redirect_to(edit_restaurant_path(@restaurant), flash: {error: "Error creating new restaurant."}) and return
    end
  end

  # DELETE /restaurants/1
  def destroy
    @restaurant = Restaurant.find(params[:id])
    @restaurant.destroy
    redirect_to(restaurants_path, flash: {success: "Restaurant was successfully deleted"}) and return
  end

 # GET /restaurant/search
 def search
   @query = "#{params[:query]}"
   @restaurants = Restaurant.query_on_constraints(query_params)
 end

private
  # Filter Params for creating and updating restaurant objects
  def create_update_params
    params.require(:restaurant).permit(:name, :url, :address, :cuisine, :menu)
  end

  def query_params
    permits = Food.generate_tags << [:query_type, :query]
    params.permit(permits)
  end

end
