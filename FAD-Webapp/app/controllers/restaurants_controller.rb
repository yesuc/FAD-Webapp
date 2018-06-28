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
    get_menu
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
      redirect_to(restaurants_path, :success => "Restaurant was successfully created.") and return
    else
      redirect_to(new_restaurant_path(@restaurant), :error => "Error creating new restaurant.") and return
    # respond_to do |format|
    #   if @restaurant.save
    #     format.html { redirect_to @restaurant, notice: 'Restaurant was successfully created.' }
    #     format.json { render :show, status: :created, location: @restaurant }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @restaurant.errors, status: :unprocessable_entity }
    #   end
    end
  end
  def get_menu
    @restaurant = Restaurant.find(params[:id])
    @url = @restaurant.url
    python_output = `python /Users/priyadhawka/Desktop/FAD-Webapp/FAD-Webapp/app/controllers/run_spiders.py #{@url}`
    file = File.read('menu_data.json')
    menu_hash = JSON.parse(file)
    @restaurant.menu = menu_hash.to_s
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
    params.require(:restaurant).permit(:name, :url, :address, :cuisine)
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end

end
