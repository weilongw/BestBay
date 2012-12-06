##
# Make a slight change to the Users table
class AddPasswordDigestToUsers < ActiveRecord::Migration

  # Add a encrypted password field in the Users table
  def change
    add_column :users, :password_digest, :string
  end
end
