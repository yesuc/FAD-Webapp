class AddFoodsToMenu < ActiveRecord::Migration[5.2]
  def change
    add_reference :foods, :menu, foreign_key: true
  end
end
