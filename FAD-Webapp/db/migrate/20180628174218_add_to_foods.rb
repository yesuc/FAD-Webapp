class AddToFoods < ActiveRecord::Migration[5.2]
  def change
     add_reference :foods, :restaurant, foreign_key: true
  end
end
