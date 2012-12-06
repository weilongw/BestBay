require 'spec_helper'

describe Product do
  before do
    @product = Product.new(product_name: "Lamp", start_price: 20,
                     buy_out_price: 40, description: "foobar", owner_id: 1,
					 photo_file_name: "1.jpg", photo_content_type: "image/jpeg",
					 photo_file_size: 1000, category_id: 1,
                     created_at: Time.now.utc,
                     end_date: Time.now.utc + 2.days)
    @product.save
  end
  subject { @product }

  it { should respond_to(:product_name) }
  it { should respond_to(:start_price) }
  it { should respond_to(:description) }
  it { should respond_to(:buy_out_price) }
  it { should respond_to(:count_click)}
  it { should respond_to(:current_bid_price)}
  it { should respond_to(:end_date)}
  it { should respond_to(:product_rate)}
  it { should respond_to(:photo)}
  it { should respond_to(:owner_id) }

  it { should be_valid }
  
end
