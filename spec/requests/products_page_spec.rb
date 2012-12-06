require 'spec_helper'

describe "Product pages" do

  subject { page }

  before do
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @user3 = FactoryGirl.create(:user)
    @product = FactoryGirl.create(:product)
    @product2 = FactoryGirl.create(:product)
  end
  
  before {
      valid_signin @user1
      post_product @product
      post_product @product2
      signout
  }

  describe "signin as the product owner" do
    before { valid_signin @user1 }
    it "should be able to visit product show page" do
      visit '/products/' + @product.id.to_s 
      page.should have_content(@product.description)
    end
    it "should have a product" do
      visit '/products'
      page.should have_content(@product.product_name)
    end
    it "should be able to see a cancel auction button on product show page" do
      visit '/products/' + @product.id.to_s
      page.should have_button('Cancel auction')
    end
    it "should not be able to see the bid or buyout button" do
      visit '/products/' + @product.id.to_s
      page.should_not have_button('Buy Now')
      page.should_not have_button('Bid')
    end
    describe "after cancel the auction" do
      before {
        visit '/products/' + @product.id.to_s
        click_button 'Cancel auction'
      }
      it "seller should receive notification" do
        page.should have_content("1 new message")
      end
      it "product should not appear in the index page" do
        visit '/products'
        page.should_not have_content(@product.product_name)
      end
    end
    describe "try to cancel the auction" do
      before {
        signout
        valid_signin @user2
        visit '/products/' + @product.id.to_s
      }
      it "should not be able to do so after someone has bid on it" do
        fill_in "bid", with: @product.start_price + 1
        click_button "Bid"
        signout
        valid_signin @user1
        visit '/products/' + @product.id.to_s
        page.should_not have_button('Cancel auction')
      end
      it "should not be able to do so after someone has buyout it" do
        click_button "Buy Now"
        signout
        valid_signin @user1
        visit '/products/' + @product.id.to_s
        page.should_not have_button('Cancel auction')
      end
    end
  end

  describe "before signin" do
    it "scheduler should be running" do
      SCHEDULER.should_not be_nil
    end
    
    it "should not access post product page" do
      visit '/products/new'
      page.should have_content('sign in')
    end
    it "should be able to visit product index page" do
      visit root_path
      page.should have_content('All products')
    end
    it "should be able to visit product show page" do
      visit '/products/' + @product.id.to_s 
      page.should have_content(@product.description)
    end
    it "should have a product" do
      visit '/products'
      page.should have_content(@product.product_name)
    end
    it "should not be able to see the bid button" do
      visit '/products/' + @product.id.to_s
      page.should_not have_button('Bid')
    end
    it "should not be able to see the buyout button" do
      visit '/products/' + @product.id.to_s
      page.should_not have_button('Buy Now')
    end
    it "should not be able to see the cancel auction button" do
      visit '/products/' + @product.id.to_s
      page.should_not have_button('Cancel auction')
    end
    it "should be able to search a product" do
      visit '/products'
      fill_in "search", with: @product.product_name
      click_button "Search"
      page.should have_content(@product.description)
      page.should_not have_content(@product2.description)
    end

    it "should not be able to find the product by a bad search" do
      visit '/products'
      fill_in "search", with: "bad_search"
      click_button "Search"
      page.should_not have_content(@product.description)
    end

    it "should be able to search with multiple keywords" do
      visit '/products'
      fill_in "search", with: @product.product_name[8..(@product.product_name.length - 1)] + " " + @product2.product_name[8..(@product2.product_name.length - 1)] 
      click_button "Search"
      page.should have_content(@product.description)
      page.should have_content(@product2.description)
    end
  end

  describe "after signin" do
    before { valid_signin @user2 }
    it "should be the right user" do
      @user2.email.should_not == @user1.email
    end
    it "should access post product" do
      visit '/products/new'
      page.should have_content('Welcome')
    end
    it "should be able to visit product index page" do
      visit root_path
      page.should have_content('All products')
    end
    it "should have a product" do
      visit '/products'
      page.should have_content(@product.product_name)
    end
    it "should be able to search a product" do
      visit '/products'
      fill_in "search", with: @product.product_name
      click_button "Search"
      page.should have_content(@product.description)
    end

    it "should not be able to find the product by a bad search" do
      visit '/products'
      fill_in "search", with: "bad_search"
      click_button "Search"
      page.should_not have_content(@product.description)
    end

    describe "in product#show page" do
      before { visit '/products/' + @product.id.to_s }
      it "should not be able to bid a product with a lower price" do
        fill_in "bid", with: @product.start_price - 10
        click_button "Bid"
        page.should have_content('Bid price wrongs?')
        end
      it "should be able to bid a product" do
        fill_in "bid", with: @product.start_price + 1
        click_button "Bid"
        page.should have_content('successfully bid')
      end
      it "should not accept a invalid bid" do
        fill_in "bid", with: "wrong bid"
        click_button "Bid"
        page.should have_content("Bid price wrongs?")
      end
      describe "buyout acts normally" do
        before do
          click_button "Buy Now"
          signout
        end
        it "buyer should receive notification" do
          valid_signin @user2
          page.should have_content('1 new message')
        end
        it "buyer should be able to rate the product" do
          valid_signin @user2
          visit '/products/' + @product.id.to_s
          #page.should have_button('Rate')
          #find(:xpath, "//input[@id='appendedPrependedInput']").set "3"
          #fill_in "rate", with: "3"
          @product.rating.should be_nil
          @user1.rating.should be_nil
          click_button "Rate"
          page.should_not have_button('Rate')
          page.should have_content('Buyer\'s Rating')
          Product.find_by_id(@product.id).rating.should_not be_nil
          User.find_by_id(@user1.id).rating.should_not be_nil
          
        end
        it "seller should receive notification" do
          valid_signin @user1
          page.should have_content('1 new message')
        end
      end
      describe "if bid is outbid" do
        before {
          fill_in "bid", with: @product.start_price + 1
          click_button "Bid"
          signout
          valid_signin @user3
          visit '/products/' + @product.id.to_s
          fill_in "bid", with: @product.start_price + 2
          click_button "Bid"
          signout
        }
        it "first bidder should receive notification" do
          valid_signin @user2
          page.should have_content('1 new message')
        end
      end
    end

  end

end
