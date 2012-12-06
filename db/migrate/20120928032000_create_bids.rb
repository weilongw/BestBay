##
# Create bid table in database
class CreateBids < ActiveRecord::Migration

  # Add following fields in the bid table
  def change
    create_table :bids do |t|
      t.integer :user_id
      t.integer :product_id
      t.decimal :price
      t.timestamps
    end
  end
end
