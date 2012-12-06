# Add a column named rating(which is a integer in range of 1 to 5) to the product table
class AddRatingToProducts < ActiveRecord::Migration
  
  # Add the rating field(which is an integer in range of 1 to 5) to product model
  def change
    add_column :products, :rating, :integer
  end
end
