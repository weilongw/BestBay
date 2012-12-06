# Add a column named closed(which is a boolean indicating whether or not a product is closed) to the product table
class AddClosedFieldToProduct < ActiveRecord::Migration

  # Add attachment photo to products
  def change
    add_column :products, :closed, :boolean, :default =>false

  end
end
