# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  first_name      :string(255)
#  last_name       :string(255)
#  address         :string(255)
#  phone           :string(255)
#  seller_rate     :decimal(, )
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#

require 'spec_helper'

describe User do

  it "has a valid factory" do
    FactoryGirl.create(:user).should be_valid
  end
  it "is invalid with no email" do
    FactoryGirl.build(:user, email: nil).should_not be_valid
  end
  it "is invalid with no address" do
    FactoryGirl.build(:user, address: nil).should_not be_valid
  end
  it "is invalid with no first name" do
    FactoryGirl.build(:user, first_name: nil).should_not be_valid
  end
  it "is invalid with no last name" do
    FactoryGirl.build(:user, last_name: nil).should_not be_valid
  end
  it "is is invalid without a password" do
    FactoryGirl.build(:user, password: nil).should_not be_valid
  end
  it "is invalid without a a password confirmation" do
    FactoryGirl.build(:user, password_confirmation: nil).should_not be_valid
  end

  it "is invalid if password is not identical to password confirmation" do
    t = FactoryGirl.build(:user, password: "abcdefg", password_confirmation: "123456").should_not be_valid
  end
end

