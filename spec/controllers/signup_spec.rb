require 'spec_helper'

describe "Signup pages" do
  subject { page }
  
  before do
    @user = FactoryGirl.create(:user)
    @product = FactoryGirl.create(:product)
  end

  before {
    valid_signin @user
    post_product @product
    visit '/'
    click_link 'Sign out'
  }

  describe "signup" do

    before { visit '/signup' }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "user[first_name]",         with: "A"
		fill_in "user[last_name]",         with: "B"
        fill_in "user[email]",        with: "user@example.com"
        fill_in "user[password]",     with: "foobar"
        fill_in "user[password_confirmation]", with: "foobar"
		fill_in "user[address]",    with: "abcd"
		fill_in "user[phone]",     with: "123-456-7890"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end
end
