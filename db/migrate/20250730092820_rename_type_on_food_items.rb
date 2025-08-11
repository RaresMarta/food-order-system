class RenameTypeOnFoodItems < ActiveRecord::Migration[8.0]
  def change
    rename_column :food_items, :type, :category
  end
end
