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
