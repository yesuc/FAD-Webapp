require 'json'
class RestaurantsController < ApplicationController
  # before_action :set_restaurant, only: [:show, :edit, :update, :destroy]

  # GET /restaurants
  # GET /restaurants.json
  def index
    @restaurants = Restaurant.all
  end

  # GET /restaurants/1
  # GET /restaurants/1.json
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
  # POST /restaurants.json
  def create
    @restaurant = Restaurant.new(create_update_params)
    if @restaurant.save
        scrape_menu
      redirect_to(restaurant_path(@restaurant), :success => "Restaurant was successfully created.") and return
    else
      redirect_to(new_restaurant_path(@restaurant), :error => "Error creating new restaurant.") and return
    end
  end
  def scrape_menu
    if !@restaurant.foods.present?
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
  #
  def menu_item_ingredients(restaurant)
    restaurant.foods.each do |food|
      food.ingredients = Food.get_ingredients(food)
      # Food.check_restrictions(food, :gluten)
    end
  end
  # PATCH/PUT /restaurants/1
  # PATCH/PUT /restaurants/1.json
  def update

  end

  # DELETE /restaurants/1
  # DELETE /restaurants/1.json
  def destroy
    @restaurant = Restaurant.find(params[:id])
    @restaurant.destroy
  end

 def search
   @q = "#{params[:query]}"
   @restaurants = Restaurant.filter_on_constraints()
   # @restaurants = Restaurant.where("name LIKE ? or url LIKE ? or address LIKE ? or cuisine LIKE ?", @q,@q,@q,@q).distinct
 end

private
  # Filter Params for creating and updating restaurant objects
  def create_update_params
    params.require(:restaurant).permit(:name, :url, :address, :cuisine, :menu)
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end

end
