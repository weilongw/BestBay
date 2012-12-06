include ApplicationHelper

# A helper function used in rspec test, faking to sign in the website
def valid_signin(user)
  visit '/signin'
  fill_in "session[email]",    with: user.email
  fill_in "session[password]", with: user.password
  click_button "Sign in"

  cookies[:remember_token] = user.remember_token

end

# A helper function uded in rspec test, faking to sign out of website
def signout
    visit root_path
    click_link "Sign out"
end

# A helper function used in rspec test, faking to post a new product
def post_product(product)
    visit '/products/new'
    fill_in "product[product_name]", with: product.product_name
    fill_in "product[start_price]", with: product.start_price
    #fill_in "product_photo", with: product.photo_file_name
    attach_file('product[photo]', File.dirname(__FILE__) + '/' + product.photo_file_name)
    fill_in "product[description]", with: product.description

    click_button "Post!"
end
