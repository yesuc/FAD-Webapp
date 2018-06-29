class AddColumnsToFood < ActiveRecord::Migration[5.2]
  def change
       add_column :foods, :name, :string, default: ""
       add_column :foods, :description, :text, default: ""
  end
end
