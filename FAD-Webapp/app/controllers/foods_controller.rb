class FoodsController < ApplicationController

    private
  def create_update_params
    params.require(:food).permit(:contains_gluten, :contains_dairy, :contains_treenuts, :contains_beef, :contains_pork, :contains_soy, :contains_egg, :contains_shellfish, :contains_peanut, :contains_fish, :contains_sesame, :contains_other)
  end
end
