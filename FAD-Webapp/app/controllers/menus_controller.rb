require 'json'
class MenusController < ApplicationController


  def new
    @menu = Menu.new
  end

  def create
    @restaurant = Restaurant.find(params[:id])
    @menu = Menu.new(create_update_params)
    @restaurant.menus << @menu
    # if @menu.save
    #   redirect_to(restaurant_menu) and return
    # end
  end

  def show
    @menu = Restaurant.find(params[:id]).menus
  end

  def index
    @menus = Menu.all
  end

  def update
  end

  def destroy
  end


  private
  def create_update_params
    params.require(:menu).permit(:menu_type, :menu_data)
  end
end
