##
# Helper module for Products View
module ProductsHelper
  #method closes this given product, assuming the user passed in has just won the product
  def close_bid(product)
    if product.closed
	  return
	end
    #user_id is of the user who has just won the auction
    product = Product.find_by_id(product.id)

    if(product.current_bid_id.nil?)
      result = create_notification(product.owner_id, "Your product was not sold, " + "<a href='/products/"+ product.id.to_s + "'>" + product.product_name.to_s + "</a>")
    else
      result = create_notification(product.owner_id, "Your product was successfully sold, " + "<a href='/products/"+ product.id.to_s + "'>" + product.product_name.to_s + "</a>")
      result = create_notification(product.current_bid_id, "You won the product, " + "<a href='/products/"+ product.id.to_s + "'>" + product.product_name.to_s + "</a>")
	  
	  user_notify = Bid.find_all_by_product_id(product.id)
	  user_notify.each do |biduser|
		if (biduser.user_id != product.current_bid_id)
			create_notification(biduser.user_id, "You didn't win the product, " + "<a href='/products/"+ product.id.to_s + "'>" + product.product_name.to_s + "</a>")
		end		
	  end
    end

    #update the end date of the product just sold
    product.closed = true

    product.end_date = Time.now.utc
    product.save
  end

  #method is a helper method to check if the current time is past the end date of the auction
  def ended(id)
    @product = Product.find_by_id(id)
    return @product.closed
  end

end
