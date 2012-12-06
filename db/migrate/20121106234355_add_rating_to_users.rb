# Add a rating column(which is decimal in range of 1.00 to 5.00) to the user table
class AddRatingToUsers < ActiveRecord::Migration
  
  # Add the rating field(which should be a decimal number in range of 1.00 to 5.00) in the user model 
  def change
    add_column :users, :rating, :decimal
  end
end
