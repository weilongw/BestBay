# == Schema Information
#
# Table name: categories
#
#  id            :integer          not null, primary key
#  category_name :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'spec_helper'

describe Category do
  before do
    @category = Category.new(category_name: 'game')
  end
  subject(@category)

  it { should respond_to(:category_name)}
  it { should respond_to(:id) }
end
