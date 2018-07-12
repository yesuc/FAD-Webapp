require 'json'
class RestaurantsController < ApplicationController

  # GET /restaurants
  @@tags = Food.generate_tags
  def index
    @restaurants = Restaurant.all
  end

  # GET /restaurants/1
  def show
    @restaurant = Restaurant.find(params[:id])
    @foods = @restaurant.foods
    if !@restaurant.scraped
        get_menu_and_food_ingredients
    end
    if session[:tags]
      session[:tags].each do |t|
        check_food_for_allergens(@restaurant.foods, t.to_sym)
      end
      session[:tags].each do |allergen|
        @foods = @foods.where("contains_#{allergen}".to_sym => false)
      end
    end
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
    get_menu_and_food_ingredients
    @restaurant.scraped = true
    if session[:tags]
      session[:tags].each do |t|
        check_food_for_allergens(@restaurant.foods, t.to_sym)
      end
    end
    if @restaurant.save
      redirect_to(restaurant_path(@restaurant), flash: {success: "Restaurant was successfully created."}) and return
    else
      redirect_to(new_restaurant_path(@restaurant), flash: {error: "Error creating new restaurant."}) and return
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
   params = query_params
   if !params[:query].nil?
     session[:query] = params[:query]
     session[:query_type] = params[:query_type]
     session[:query_distance] = params[:query_distance]
   else
     params[:query] = session[:query]
     params[:query_type] = session[:query_type]
     params[:query_distance] = session[:query_distance]
   end
   @query = params[:query]
   if !session[:tags].nil?
     session[:tags].each do |tag|
       if !params.include?(tag)
         params << tag
       end
     end
   else
     session[:tags] = []
     Food.generate_tags.each do |tag|
       if params[tag] && !session[:tags].include?(tag)
         session[:tags] << tag
       end
     end
   end
   @allergens = session[:tags]
   @restaurants = Restaurant.query_on_constraints(params)
 end


  def get_menu_and_food_ingredients
    double_check = scrape_menu
    if !double_check.empty?
      get_ingredients_for_all(double_check)
      @restaurant.scraped = true
      @restaurant.save
    end
  end

# If a restaurant does not contain a menu:
# Get menu items and descriptions from menu_data.json, create new food items, with name and description
# Runs python script in run_spiders.py which in turn calls menu_spider.py with the restaurant url
#NOTE: scrape_menu is currently called in controller function show since no new restaurants are being created
  def scrape_menu
    @url = @restaurant.url
    double_check = {}
    python_output = `python /Users/carteryesu/Desktop/FAD-Webapp/FAD-Webapp/app/controllers/run_spiders.py #{@url}`
    file = File.read('menu_data.json')
    menu_hash = JSON.parse(file)
    @restaurant.menu = menu_hash.values
    @menu = menu_hash.values
      @menu.each do |item|
        item.each do |i|
          @food = Food.create!(:name => i[0], :description => i[1])
          @restaurant.foods << @food
          double_check[@food] = @food.name
        end
    end
    return double_check
  end

# NOTE: Gets ingredients for all food items by running bing.py
def get_ingredients_for_all(double_check)
  double_check_values = double_check.values.to_json
  python_output = `python /Users/carteryesu/Desktop/FAD-Webapp/FAD-Webapp/app/controllers/webcrawler/webcrawler/spiders/bing.py #{double_check_values}`
  file = File.read('ingredients_data.json')
  ingredients_hash = JSON.parse(file)
  ingredients_hash = ingredients_hash.values
  double_check.keys.each_with_index do |key,index|
    if !ingredients_hash[index].nil?
      key.ingredients = ingredients_hash[index].join(' ').strip().downcase
      key.save!
    end
  end
end

# NOTE: Takes foods association and checks if food name, description or ingredients contain allergen
def check_food_for_allergens(foods, restriction)
    contains = "contains_"+ restriction.to_s
    contains = contains.to_sym
    foods.each do |food|
      food_name = food.name.downcase
      food_description = food.description.downcase
      food_ingredients = food.ingredients
      if Food.check_restrictions(food_description.split(), restriction) || Food.check_restrictions(food_name.split(), restriction) || Food.check_restrictions(food_ingredients.split(), restriction)
        food[contains]= true
        food.save!
      else
        food[contains]= false
        food.save!
      end
    end
end

private
  # Filter Params for creating and updating restaurant objects
  def create_update_params
    params.require(:restaurant).permit(:name, :url, :address, :cuisine, :menu)
  end

  def query_params
    permits = Food.generate_tags << [:query, :query_type, :query_distance,:order]
    params.permit(permits)
  end

end
