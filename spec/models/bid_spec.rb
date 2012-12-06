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

require 'spec_helper'

describe Bid do
  before do
    @bid = Bid.new(product_id: 1, user_id: 1, price: 20)
    @bid.save
  end

  subject {@bid}

  it {should respond_to(:product_id) }
  it {should respond_to(:user_id) }
  it {should respond_to(:price) }
end
