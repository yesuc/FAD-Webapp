class FoodsController < ApplicationController

  # GET /foods/1/edit
  def edit
    @food = Food.find(params[:id])
  end

  # PATCH/PUT /food/1
  def update
    @food = Food.find(params[:id])
    @food.update(create_update_params)
    if @food.save
      flash[:success]= "Food update successful."
      redirect_to restaurant_path(@food.restaurant.id) and return
    else
      flash[:warning]= "Food update failed."
      redirect_to edit_restaurant_food_path(@food.id) and return
    end
  end
  
  def destroy
    @food = Food.find(params[:id])
    @food.destroy
    flash[:notice] = "Food Successfully Deleted!"
    redirect_to restaurant_path(@food.restaurant.id) and return
  end


private
  def create_update_params
    params.require(:food).permit(:name,:description, :ingredients)
  end
end
