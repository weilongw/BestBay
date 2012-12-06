# == Schema Information
#
# Table name: bids
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  product_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

##
# class represents the Bid model: for when a buyer places a bid
class Bid < ActiveRecord::Base
  attr_accessible :product_id, :user_id, :price

  belongs_to :user
  belongs_to :product
end
