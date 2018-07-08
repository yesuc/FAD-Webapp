class CreateRestaurants < ActiveRecord::Migration[5.2]
  def change
    create_table :restaurants do |t|
      t.string :name, null: false
      t.string :url
      t.string :address
      t.string :cuisine
      t.string :description
      t.boolean :scraped, default: false

      t.timestamps
    end
  end
end
