##
# Add the RememberToken field to Users table
class AddRememberTokenToUsers < ActiveRecord::Migration
  
  # Add RememberToken field and make index for it in the Users table
  def change
    add_column :users, :remember_token, :string
    add_index  :users, :remember_token
  end
end
