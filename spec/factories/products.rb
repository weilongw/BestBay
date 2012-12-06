# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do |t|
    t.sequence(:id) {|n| n}
    t.category_id 1
    t.owner_id 1
    t.sequence(:product_name) {|n| "MyString#{n}" }
    t.sequence(:description) {|n| "MyString#{n}" }
    t.photo_file_name "1.jpg"
    t.photo_file_size 1000
    t.start_price 100
    t.count_click 1
    #t.rating 1
    t.current_bid_price 100
    t.created_at Time.now.utc
    t.end_date Time.now.utc + 2.days
  end
end
