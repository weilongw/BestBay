##
# Create notifications table 
class CreateNotifications < ActiveRecord::Migration

  # Create notifications table and add following fields 
  def change
    create_table :notifications do |t|
      t.string :post
      t.integer :user_id
      t.integer :unread

      t.timestamps
    end
  end
end
