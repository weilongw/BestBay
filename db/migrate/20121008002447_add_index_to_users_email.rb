##
# Add index to the email field in the Users table
class AddIndexToUsersEmail < ActiveRecord::Migration

  # Add index to the email field in the Users table
  def change
    add_index :users, :email, unique: true
  end
end
