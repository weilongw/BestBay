namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_categories
    make_users
	make_products
  end
end

def make_categories
  Category.create!(category_name: "Appliance")
  Category.create!(category_name: "Electronics")
  Category.create!(category_name: "Books")
  Category.create!(category_name: "Grocery")
  Category.create!(category_name: "Game & Entertainment")
  Category.create!(category_name: "Sports")
  Category.create!(category_name: "Other")
end

def make_users
   User.create!(
    address: "123",
    email: "kidfrompg@gmail.com",
    first_name: "Bill",
    last_name: "Ge",
    password: "kidfrompg",
    phone: "1231231234",
    seller_rate: 0,
    password_confirmation: "kidfrompg"
   )
end






def make_products
	20.times do |n|
		f_product_name = Faker::Lorem.words.join(" ")
		f_start_price = rand(100..200)
		f_current_bid_price = f_start_price
		f_buy_out_price = rand(300..400)
		f_description = Faker::Lorem.sentences(2).join(" ")
		f_category_id = rand(1..7)
		f_owner_id = 1
		f_photo_file_name = "product.png"
		f_photo_content_type = "image/png"
#		f_photo_file_size = 176451
		f_end_date = Time.now.utc+2.days
		f_count_click = 0
		Product.create!(product_name:f_product_name, start_price:f_start_price, current_bid_price:f_current_bid_price, buy_out_price: f_buy_out_price, description:f_description, category_id:f_category_id, owner_id:f_owner_id, photo_file_name:f_photo_file_name, photo_content_type:f_photo_content_type, end_date:f_end_date, count_click:f_count_click)
#	photo_file_size:f_photo_file_size, 
	end
end
