require 'json'
class RestaurantsController < ApplicationController

  # GET /restaurants
  def index
    @restaurants = Restaurant.all
  end

  # GET /restaurants/1
  def show
    @tags = Food.generate_tags
    @tags.delete('other')
    @restaurant = Restaurant.find(params[:id])
    @foods = @restaurant.foods
    if !@restaurant.scraped
        get_menu_and_food_ingredients
        @tags.each do |t|
          check_food_for_allergens(@restaurant.foods, t.to_sym)
        end
        @restaurant.save!
    end
    if session[:tags]
      session[:tags].each do |allergen|
        @foods = @foods.where("contains_#{allergen}".to_sym => false)
        @foods.distinct
      end
    else
      @foods.distinct
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
    @tags = Food.generate_tags
    @tags.delete('other')
    @tags.each do |t|
      check_food_for_allergens(@restaurant.foods, t.to_sym)
    end
    # if session[:tags]
    #   session[:tags].each do |t|
    #     check_food_for_allergens(@restaurant.foods, t.to_sym)
    #   end
    # end
    if @restaurant.save
      if @restaurant.admin_approved
        flash[:success] = "New restaurant \'#{@restaurant.name}\' created and added to the page"
      else
         flash[:notice] = "New restaurant \'#{@restaurant.name}\' awaiting approval"
       end
       redirect_to restaurants_path and return
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
   session[:init] = true
   if should_set_session? params, session
     session = clear_session_query_attr
     session = set_session(params, session)
   elsif should_set_params? params
     params = set_params(params, session)
     session = clear_session_query_attr
   end
   @query = params[:query]
   @query_type = params[:query_type]
   @query_distance = params[:query_distance]
   @query_order = params[:order]
   if session.nil?
     @allergens = nil
   else
     @allergens = session[:tags]
   end
   @restaurants = Restaurant.query_on_constraints(params)
 end

#Calls scrape_menu to get an array of all foods from a specific restaurant & gets ingredients for all foods in double check
  def get_menu_and_food_ingredients
    double_check = scrape_menu
    if !double_check.empty?
      get_ingredients_for_all(double_check)
      @restaurant.scraped = true
    end
  end

# If a restaurant does not contain a menu:
# Get menu items and descriptions from menu_data.json, create new food items, with name and description
# Runs python script in run_spiders.py which in turn calls menu_spider.py with the restaurant url
#NOTE: scrape_menu is currently called in controller function show since no new restaurants are being created
  def scrape_menu
    @url = @restaurant.url
    double_check = {}
    python_output = `python app/controllers/run_spiders.py #{@url}`
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
  double_check_values = double_check.values.join(', ').to_json
  python_output = `python app/controllers/webcrawler/webcrawler/spiders/bing.py #{double_check_values}`
  file = File.read('ingredients_data.json')
  ingredients_hash = JSON.parse(file)
  ingredients_hash = ingredients_hash.values
  double_check.keys.each_with_index do |key,index|
    if !ingredients_hash[index].nil?
      key.ingredients = ingredients_hash[index].join(', ').strip()
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
      if Food.check_restrictions(food_description.split(), restriction) || Food.check_restrictions(food_name.split(), restriction) || Food.check_restrictions(food_ingredients.downcase.split(', '), restriction)
        food[contains]= true
        food.save!
      else
        food[contains]= false
        food.save!
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
      redirect_to(edit_restaurant_path(@restaurant), flash: {error: "Attention Admin! Error creating new restaurant."}) and return
    end
  end

private
  # Filter Params for creating and updating restaurant objects
  def create_update_params
    params.require(:restaurant).permit(:name, :url, :address, :cuisine, :menu, :admin_approved, :description, :scraped)
  end


  def query_params
    permits = Food.generate_tags << [:query, :query_type, :query_distance,:order]
    params.permit(permits)
  end

  def should_set_params?(parms)
    if parms[:order]
      return true
    else
      return false
    end
  end

  def should_set_session?(parms,sess)
    if !parms[:order] || !parms[:query].nil?
        return true
    else
      return false
    end
  end

  # PARAMS: Set A, and destination Set B
  # Moves or replaces query attributes from set A into set B
  # RETURNS: destination Set B with query params from A
  def set_query_attributes(a,b)
    q_params = ['query', 'query_type', 'query_distance', 'order']
    if a.nil?
      a = {}
    end
    if b.nil?
      b = {}
    end
    q_params.each do |param|
      b[param] = a[param]
    end
    return b
  end

  # PARAMS: Params and Session Hash
  # Sets/Overwrites the Sessions Hash with query attributes from params
  # RETURNS: Params Hash with query attributes and allergen tags set from sessions
  def set_session(parms,sess)
    sess = set_query_attributes(parms,sess)
    ignore = ['query', 'query_type', 'query_distance', 'order']
    sess[:tags] = []
    parms.each do |atr,val|
      if !ignore.include?(atr)
        sess[:tags] << atr
      end
    end
    return sess
  end


  # Removes Allergen tags and query attributes from session
  # RETURNS: Session Hash with query attributes and allergen tags removed
  def clear_session_query_attr
    tags = Food.generate_tags
    q_params = ['query', 'query_type', 'query_distance', 'order']
    session.each do |a|
      if tags.include?(a) || q_params.include?(a)
        session.delete(a)
      end
    end
    return session
  end

  # PARAMS: Params and Session Hash
  # Sets/Overwrites the params query attributes with those from sess
  # RETURNS: Params with new query attributes set
  def set_params(parms,sess)
    parms = set_query_attributes(sess,parms)
    ignore = ['query', 'query_type', 'query_distance', 'order']
    sess[:tags].each do |tag|
      parms[tag] = 'on'
    end
    return parms
  end

  # => Search Bar Session + Params Management
  #INIT: (from form) params != nil, session = nil => set session with new params
  #MAINT-1: (from form) params != nil, session != nil => Wipe session and set with new params
  #MAINT-2: (from link) params = order, session != nil => set params using session, wipe session
end
