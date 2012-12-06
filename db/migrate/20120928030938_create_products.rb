##
# Create products table in database
class CreateProducts < ActiveRecord::Migration
  # add the following fields in products table
  def change
    create_table :products do |t|
      t.integer :id
      t.integer :category_id
      t.integer :owner_id
      t.integer :current_bid_id
      t.string :product_name
      t.string :description
      t.integer :count_click
      t.decimal :current_bid_price
      t.decimal :buy_out_price
      t.decimal :start_price
      t.datetime :end_date
      t.decimal :product_rate

      t.timestamps
    end
  end
end
