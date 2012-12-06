require 'will_paginate/array'
##
# Controller to handle the interaction between our Products View and our Products Model
class ProductsController < ApplicationController

before_filter :authenticate, :only => [:new,:bid, :buyout]
before_filter :other_user, :only => [:bid, :buyout]

  # initialize a new instance of a product
  def new
    @product = Product.new
    @categories = []
    Category.all.each do |category|
      each_cate = [category.category_name, category.id]
      @categories << each_cate
    end
  end

  # create a new instance of a product from the passed in parameters
  def create
    @product = Product.new(params[:product])
    @product.current_bid_price = @product.start_price
	  @product.owner_id = current_user.id
	  @product.count_click = 0
    @product.end_date = @product.end_date + 5.hours #from est to utc
    if @product.save
      flash[:success] = "You are in business now"
	    SCHEDULER.at @product.end_date.to_s() do
      close_bid(@product)
    end

      redirect_to @product
    else
	  @categories = []
	  Category.all.each do |category|
      each_cate = [category.category_name, category.id]
      @categories << each_cate
	  end
      render 'new'
    end
  end

  # getter method to return the index of the current product
  def index
	@products = Product.order("count_click DESC, created_at DESC")
    @products = @products.paginate(page: params[:page])

  # return a given product based upon a passed in parameters
    @categories = []
    Category.all.each do |category|
      each_cate = [category.category_name, category.id]
      @categories << each_cate
    end
  end

  # function helps to render the products/show page, and increases the product's 
  # count_click by 1 once a product is viewed by one user. count_click is used to help determine how to 
  # sort the products by popularity.
  def show
    @product = Product.find_by_id params[:id]
    @seller = User.find(@product.owner_id)
    if !@product.current_bid_id.nil?
      @buyer = User.find(@product.current_bid_id)
    end
	if @product.count_click.nil?
		@product.count_click = 1
	else
		@product.count_click += 1
	end
	@product.save
	
  end

  # method returns a list of search results when you search for a product through a given set of keywords
  def search
    if (params[:category].to_i == 0)
      @cat_product = Product.all
    elsif
      @cate = Category.find(params[:category])
      @cat_product = @cate.products
    end
    key = params[:search].strip
    @keys = key.split
    if key.empty?
      @products = @cat_product.sort! {|a,b| b.created_at <=> a.created_at}
    else
      @products = []
      @all = @cat_product.sort! {|a,b| b.created_at <=> a.created_at}
      @all.each do |product|
        @keys.each do |each_key|
          if product.product_name.downcase.include?(each_key.downcase)
            @products.append(product)
            break
          end
        end
      end
    end
    filter = params[:sort]
    if !filter.nil?
      if filter == 'price'
        @products.sort! {|a,b| a.current_bid_price <=> b.current_bid_price}
      elsif filter == 'time'
        @products.sort! {|a,b| b.created_at <=> a.created_at}
      end
    end
    @products = @products.paginate(page: params[:page])
    @categories = []
    Category.all.each do |category|
      each_cate = [category.category_name, category.id]
      @categories << each_cate
    end
    render 'index'
  end

  # method allows a user to make a bid on given product through the given parameters
  def bid
      bid_price = params[:bid].to_f
      bid_price = (bid_price * 100).round/100.0
      if (bid_price > @product.current_bid_price || (@product.current_bid_id.nil? && bid_price == @product.current_bid_price))
      if (!@product.buy_out_price.nil?) && (bid_price >= @product.buy_out_price)
         buyout
         return
      end

		my_bid = Bid.where(:product_id => @product.id, :user_id => current_user.id).first
		
		if my_bid.nil?
			@bid = Bid.create(:product_id => @product.id, :user_id => current_user.id, :price => bid_price)	
			@product.current_bid_price = bid_price
			@product.current_bid_id=current_user.id
			@product.save
			
			all_bid = Bid.all
				all_bid.each do |bid_1|
					if bid_1.product_id ==@product.id
						if bid_1.user_id != current_user.id
							create_notification(bid_1.user_id, "You have been out bid on a product!!!, " + "<a href='/products/"+ @product.id.to_s + "'>" + @product.product_name.to_s + "</a>, Hurry!")
						end
					end
				end
			flash[:success] = "successfully bid"
		else
			my_bid.price = bid_price
			my_bid.save
			@product.current_bid_price = bid_price
			@product.current_bid_id=current_user.id
			@product.save
			
			all_bid = Bid.all
				all_bid.each do |bid_1|
					if bid_1.product_id ==@product.id
						if bid_1.user_id != current_user.id
							create_notification(bid_1.user_id, "You have been out bid on a product!!!, " + "<a href='/products/"+ @product.id.to_s + "'>" + @product.product_name.to_s + "</a>, Hurry!")
						end
					end
				end
			
			flash[:success] = "updated your bid"
		end
      else
        flash[:error] = "Bid price wrongs?"
      end
      redirect_to  @product
  end

  # After one wins a product, he could rate the item he bought and the buyer's credit should be affected by this rating
  def rate
    @product = Product.find_by_id params[:id]
    rate = params[:rate].to_i
    if !@product.closed
      flash[:error] = "not closed, cannot rate the product"

    elsif @product.current_bid_id.nil?
      flash[:error] = "this product is not available"

    elsif @product.current_bid_id != current_user.id
      flash[:error] = "you are not the buyer"

    elsif (rate < 1 || rate > 5)
      flash[:error] = "invalid rating"
    else
    @product.update_attribute(:rating, rate)
    update_seller(@product)
    end
    redirect_to @product

  end

  # Buyout functionality. A used could win the product if he clicks the buyout button and pays the 'Buy-it-now' price.
  def buyout

    if @product.closed
      redirect_to @product
    end
    @product.current_bid_id = current_user.id
    @product.current_bid_price= @product.buy_out_price
    @product.save
	
	my_bid = Bid.where(:product_id => @product.id, :user_id => current_user.id).first
	if my_bid.nil?
		bid = Bid.create(product_id: @product.id, user_id: current_user.id, price: @product.buy_out_price)
	else
		my_bid.price = @product.buy_out_price
		my_bid.save
	end
	
    close_bid(@product)

    redirect_to @product
  end

  # cancel the current auction if nobody has bid on it yet 
  def cancel
    @product = Product.find_by_id params[:id]
    close_bid(@product)
    redirect_to @product
  end

  # A helper function used in before_filter to test whether current user is a certain product's owner
  def other_user
    @product = Product.find_by_id params[:id]

    if @product.owner_id == current_user.id
        flash[:error] = "cannot bid or buyout on your own product"
        redirect_to @product
    end
  end
 
  # To help render the products' homepage, where the items are rendered by their popularity.
  def homepage
	products2 = Product.find_all_by_closed(false)	
	@products = products2.sort! {|a,b| b.count_click <=> a.count_click}

	# return a given product based upon a passed in parameters
    @categories = []
    Category.all.each do |category|
      each_cate = [category.category_name, category.id]
      @categories << each_cate
    end
  end

  # A helper function used to update a seller's credits information once one of his product is rated by the buyer
  def update_seller(product)
    seller = User.find_by_id(product.owner_id)
    all_rated_products = Product.where(:owner_id => seller.id, :closed => true).where("rating is not null")
    tmp_rating = 0
    count = 0
    all_rated_products.each do |aProduct|
      tmp_rating += aProduct.rating
      count = count + 1
    end
    new_rating = tmp_rating.to_f() / count.to_f()
    seller.update_attribute(:rating , new_rating)

  end

end
