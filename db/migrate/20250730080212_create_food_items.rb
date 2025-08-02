class CreateFoodItems < ActiveRecord::Migration[8.0]
  def change
    create_table :food_items do |t|
      t.string :name, null: false
      t.string :type, null: false
      t.decimal :price, precision: 8, scale: 2, null: false
      t.boolean :vegetarian, default: false

      t.timestamps
    end
  end
end
