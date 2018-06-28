class AddColumnsToMenu < ActiveRecord::Migration[5.2]
  def change
    add_column :menus, :menu_data, :string, default: ""
  end
end
