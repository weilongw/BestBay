require 'spec_helper'

describe "User" do

  describe "Login page" do

    it "should have the content 'Login'" do
      visit '/signin'
      page.should have_content('Sign in')
    end
  end
  
  describe "Signup page" do

    it "should have the content 'Signup'" do
      visit '/signup'
      page.should have_content('Sign up')
    end
  end
end