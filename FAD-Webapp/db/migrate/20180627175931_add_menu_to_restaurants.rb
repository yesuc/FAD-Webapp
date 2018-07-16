class AddMenuToRestaurants < ActiveRecord::Migration[5.2]
  def change
     add_column :restaurants, :menu, :string, default: ""
     add_column :restaurants, :admin_approved, :boolean, default: false
  end
end
