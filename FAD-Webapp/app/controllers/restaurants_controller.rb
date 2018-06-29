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
    menu_item_ingredients(@restaurant)
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

  def scrape_menu
    if !@restaurant.foods.present?
      @url = @restaurant.url
      python_output = `python run_spiders.py #{@url}`
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
  #
  def menu_item_ingredients(restaurant)
    restaurant.foods.each do |food|
      food.ingredients = Food.get_ingredients(food)
      # Food.check_restrictions(food, :gluten)
    end
  end

  # PATCH/PUT /restaurants/1
  def update
<<<<<<< HEAD

=======
    @restaurant = Restaurant.find(params[:id])
    @restaurant.update(create_update_params)
    if @restaurant.save
      redirect_to(restaurant_path(@restaurant), flash: {success: "Restaurant was successfully updated."}) and return
    else
      redirect_to(edit_restaurant_path(@restaurant), flash: {error: "Error creating new restaurant."}) and return
    end
>>>>>>> 1f2076a693fe9a53f26b38bf679f7a00a20d69dd
  end

  # DELETE /restaurants/1
  def destroy
    @restaurant = Restaurant.find(params[:id])
    @restaurant.destroy
<<<<<<< HEAD
=======
    redirect_to(restaurants_path, flash: {success: "Restaurant was successfully deleted"}) and return
>>>>>>> 1f2076a693fe9a53f26b38bf679f7a00a20d69dd
  end

 # GET /restaurant/search
 def search
   @tags = query_params
   @q = "#{params[:query]}"
   @restaurants = Restaurant.filter_on_constraints()
   # @restaurants = Restaurant.where("name LIKE ? or url LIKE ? or address LIKE ? or cuisine LIKE ?", @q,@q,@q,@q).distinct
 end

private
  # Filter Params for creating and updating restaurant objects
  def create_update_params
    params.require(:restaurant).permit(:name, :url, :address, :cuisine, :menu)
  end

  def query_params
    permits = []
    Food.column_names.each do |name|
      # e.g. contains_gluten
      if name =~ /^contains/
        permits << name[name.index('_')+1..-1] + "_free" # e.g. gluten_free
      end
    end
    params.permit(permits)
  end

end
