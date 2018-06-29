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
    id = params[:id]
    @restaurant = Restaurant.find(id)
    scrape_menu
  end

  # GET /restaurants/new
  def new
    @restaurant = Restaurant.new
  end

  # GET /restaurants/1/edit
  def edit

  end

  # POST /restaurants
  # POST /restaurants.json
  def create
    @restaurant = Restaurant.new(create_update_params)
    if @restaurant.save
      scrape_menu
      redirect_to(restaurants_path, :success => "Restaurant was successfully created.") and return
    else
      redirect_to(new_restaurant_path(@restaurant), :error => "Error creating new restaurant.") and return
    end
  end
  def scrape_menu
    if @restaurant.menu.present?
      return @restaurant.foods
    else
      @url = @restaurant.url
      python_output = `python /Users/priyadhawka/Desktop/FAD-Webapp/FAD-Webapp/app/controllers/run_spiders.py #{@url}`
      file = File.read('menu_data.json')
      menu_hash = JSON.parse(file)
      @restaurant.menu = menu_hash
      @menu = menu_hash.values
      @menu.each_with_index do |item, i|
        food = Food.create(:name => item[i][0], :description => item[i][1])
        @restaurant.foods << food
      end
    end
    return @restaurant.foods
  end
  # PATCH/PUT /restaurants/1
  # PATCH/PUT /restaurants/1.json
  def update
    # respond_to do |format|
    #   if @restaurant.update(restaurant_params)
    #     format.html { redirect_to @restaurant, notice: 'Restaurant was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @restaurant }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @restaurant.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /restaurants/1
  # DELETE /restaurants/1.json
  def destroy
    @restaurant = Restaurant.find(params[:id])
    @restaurant.destroy
    # respond_to do |format|
    #   format.html { redirect_to restaurants_url, notice: 'Restaurant was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end

 def search
   @q = params[:searchbar]
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
