class CreateRestaurants < ActiveRecord::Migration[5.2]
  def change
    create_table :restaurants do |t|
      t.string :name, null: false
      t.string :url
      t.text :address
      t.string :cuisine
      t.text :description
      t.boolean :scraped, default: false
      t.decimal :latitude, precision: 15, scale: 10, null: false
      t.decimal :longitude, precision: 15, scale: 10, null: false

      t.timestamps
    end
  end
end
