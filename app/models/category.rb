# == Schema Information
#
# Table name: categories
#
#  id            :integer          not null, primary key
#  category_name :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

##
# Class represent the category model: representation of the different groups a product can fall in
class Category < ActiveRecord::Base
  attr_accessible :category_name, :id

  has_many :products
end
