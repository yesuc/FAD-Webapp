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
      redirect_to(restaurant_path(@restaurant), :success => "Restaurant was successfully created.") and return
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
    @restaurant.destroy
    # respond_to do |format|
    #   format.html { redirect_to restaurants_url, notice: 'Restaurant was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end

 def search
   @q = "#{params[:query]}"
   @restaurants = Restaurant.filter_on_constraints()
   # @restaurants = Restaurant.where("name LIKE ? or url LIKE ? or address LIKE ? or cuisine LIKE ?", @q,@q,@q,@q).distinct
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
