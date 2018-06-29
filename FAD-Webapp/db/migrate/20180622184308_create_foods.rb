class CreateFoods < ActiveRecord::Migration[5.2]
  def change
    create_table :foods do |t|
      t.boolean :contains_gluten
      t.boolean :contains_dairy
      t.boolean :contains_treenuts
      t.boolean :contains_beef
      t.boolean :contains_pork
      t.boolean :contains_soy
      t.boolean :contains_egg
      t.boolean :contains_shellfish
      t.boolean :contains_peanut
      t.boolean :contains_fish
      t.boolean :contains_sesame
      t.boolean :contains_wheat
      t.string :contains_other
      t.string :ingredients

      t.timestamps
    end
  end
end
