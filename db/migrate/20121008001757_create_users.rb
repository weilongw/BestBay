##
# Create Users table
class CreateUsers < ActiveRecord::Migration
  
  # Build Users table according to the following fields
  def change
    create_table :users do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :phone
      t.decimal :seller_rate

      t.timestamps
    end
  end
end
