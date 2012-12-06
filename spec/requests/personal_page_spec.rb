require 'spec_helper'

describe "Product pages" do

  subject { page }

  #let(:user) { FactoryGirl.create(:user) }
  #let(:product) { FactoryGirl.create(:product) }
  before do
    @user = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @user3 = FactoryGirl.create(:user)
    @product = FactoryGirl.create(:product)
  end

  before {
      valid_signin @user
      post_product @product
      signout
  }
  
  describe "before signin" do
    it "should not access personal information page" do
      visit '/profile'
      page.should have_content('sign in')
    end
	it "should not access my buying page" do
      visit '/buying'
      page.should have_content('sign in')
    end
	it "should not access my selling page" do
      visit '/selling'
      page.should have_content('sign in')
    end
	it "should not access notification page" do
      visit '/notification'
      page.should have_content('sign in')
    end
  end

  describe "poster of the product closes his own product" do
    before do
      valid_signin @user
      visit '/products/' + @product.id.to_s
      click_button "Cancel auction"
    end
    it "should receive notification" do
      visit '/notification'
      page.should have_content('1 new message')
      page.should have_content('Notification[1]')
      page.should have_content('Your product was not sold')
      page.should have_link @product.product_name
    end
    it "product show page should be updated accordingly" do
      visit '/products/' + @product.id.to_s
      page.should have_content('Nobody buys')
      page.should_not have_button('Bid')
      page.should_not have_button('Buy Now')
      page.should_not have_button('Cancel auction')
    end
  end
  describe "user2 buyout the product after signin" do
    before { 
      valid_signin @user2
      visit '/products/' + @product.id.to_s
      click_button "Buy Now"
    }
    it "should access to profile page" do
      visit '/profile'
      page.should have_content('profile')
    end
    it "should access to buying page" do
      visit '/buying'
      page.should have_content('buyings')
    end
    it "should access to selling page" do
      visit '/selling'
      page.should have_content('sellings')
    end
    it "should access to notification page" do
      visit '/notification'
      page.should have_content('Your Notifications')
    end
    describe "in notification page" do
      before { visit '/notification' }
      it "should receive a notification" do
        page.should have_content('You won the product')
      end
      it "should have notification in header html" do
        page.should have_content('1 new message')
      end
      it "should have number count after notification in sidebar" do
        page.should have_content('Notification[1]')
      end
      it "should have the unread button" do
        page.should have_button('Mark as Read')
      end
      it "should have a link to the product" do
        page.should have_link @product.product_name
      end
    end
    describe "user who post the product should receive notification" do
      before {
        signout
        valid_signin @user
        visit '/notification'
      }
      it "should receive a notification" do
        page.should have_content('Your product was successfully sold')
      end
      it "should have a link to the product" do
        page.should have_link @product.product_name
      end
      it "should have notification in header html" do
        page.should have_content('1 new message')
      end
      it "should have number count after notification in sidebar" do
        page.should have_content('Notification[1]')
      end
      it "should have the unread button" do
        page.should have_button('Mark as Read')
      end
      describe "click the 'Mark as Read' button" do
        before {
          click_button "Mark as Read"
        }
        it "should not have notification in header html" do
          page.should_not have_content('1 new message')
        end
        it "should not have number count after notification in sidebar" do
          page.should_not have_content('Notification[1]')
        end
        it "should not have the unread button" do
          page.should_not have_button('Mark as Read')
        end 
      end
    end
	it "should display the user's email information in sidebar" do
	  visit '/profile'
	  page.should have_content(@user2.email)
	end	
	it "in selling page you should not be able to see the product" do
	  visit '/selling'
	  page.should_not have_content(@product.product_name)
	end	
	it "should display the things you're buying" do
	  visit '/buying'
	  page.should have_content(@product.product_name)
	end
	
  end
  describe "a user is outbid by another user" do
    before do 
      valid_signin @user2
      visit '/products/' + @product.id.to_s
      fill_in "bid", with: @product.start_price + 1
      click_button "Bid"
      signout
      valid_signin @user3
      visit '/products/' + @product.id.to_s
      fill_in "bid", with: @product.start_price + 2
      click_button "Bid"
      signout
    end
    describe "the first bidder" do
      before { valid_signin @user2 }
      it "should receive notification" do
        visit '/notification'
        page.should have_content('1 new message')
        page.should have_content('Notification[1]')
        page.should have_content('You have been out bid on a product!!!,')
        page.should have_link @product.product_name
      end
      it "buying page should be updated accordingly" do
        visit "/buying"
        page.should have_content @product.product_name
        page.should have_content ('Your bid price: ' + (@product.start_price + 1).to_s)
        page.should have_content ('Current price: ' + (@product.start_price + 2).to_s)
      end
    end
    describe "the second bidder" do
      before { valid_signin @user3 }
      it "buying page should be updated accordingly" do
        visit "/buying"
        page.should have_content @product.product_name
        page.should have_content('Your bid price: ' + (@product.start_price + 2).to_s)
        page.should have_content('Current price: ' + (@product.start_price + 2).to_s)

      end
    end
  end


end
