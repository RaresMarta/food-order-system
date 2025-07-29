class CreateTableFoodItem < ActiveRecord::Migration[8.0]
  def change
    create_table :table_food_items do |t|
      t.timestamps
    end
  end
end
