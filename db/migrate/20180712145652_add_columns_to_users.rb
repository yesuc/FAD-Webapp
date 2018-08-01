class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :name, :string
    add_column :users, :gluten, :boolean, default: false
    add_column :users, :dairy, :boolean, default: false
    add_column :users, :treenuts, :boolean, default: false
    add_column :users,:beef, :boolean, default: false
    add_column :users, :pork, :boolean, default: false
    add_column :users, :soy, :boolean, default: false
    add_column :users, :egg, :boolean, default: false
    add_column :users, :shellfish, :boolean, default: false
    add_column :users, :peanut, :boolean, default: false
    add_column :users, :fish, :boolean, default: false
    add_column :users, :sesame, :boolean, default: false
    add_column :users, :wheat, :boolean, default: false
  end
end
