class UsersController < ApplicationController
  def edit
    id = params[:id]
    @user = User.find(id)
  end

  def show
    if !current_user.nil?
       @user = current_user.id == params[:id] ? User.find(current_user.id) : User.find(params[:id])
     end
  end

  def update
    @user = User.find(params[:id])
    @user.update(create_update_params)
    if @user.save
      flash[:sucess] = "Food Allergens & Restrictions updated!"
      redirect_to user_path(@user)and return
    else
      flash[:error] = "Error updating Food Allergens & Restrictions."
      redirect_to edit_user_path(@user) and return
    end
  end

  def view
    @user = User.find(params[:id])
  end

  def destroy
   @user = current_user.id == params[:id] ? User.find(current_user.id) : User.find(params[:id])
   @user.destroy
   flash[:notice] = "Account Successfully Deleted!"
   redirect_to root_path
  end
  private
  def create_update_params
    params.require(:user).permit(:gluten, :dairy, :treenuts, :beef, :pork, :soy, :egg, :fish, :shellfish, :peanuts, :sesame, :wheat, :other)
  end
end
