##
# Create category table
class CreateCategories < ActiveRecord::Migration

  # Build category table according to following fields
  def change
    create_table :categories do |t|
      t.integer :id
      t.string :category_name

      t.timestamps
    end
  end
end
