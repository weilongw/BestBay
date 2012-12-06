##
# To add/drop a column photo(indicating the product's attachment photo) to the product table.
class AddAttachmentPhotoToProducts < ActiveRecord::Migration
 
  # Add attachment photo to products
  def self.up
    change_table :products do |t|
      t.has_attached_file :photo
    end
  end

  # Rollback database to drop photos
  def self.down
    drop_attached_file :products, :photo
  end
end
