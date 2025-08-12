class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.string  :payment_method, null: false
      t.decimal :total_price, precision: 10, scale: 2, null: false, default: 0

      t.timestamps
    end
  end
end
