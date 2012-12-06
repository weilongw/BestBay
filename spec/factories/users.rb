# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do |t|
    t.sequence(:email) { |n| "a#{n}@b.com" }
    t.sequence(:first_name)  { |n| "a#{n}" }
    t.sequence(:last_name)  { |n| "b#{n}" }
    t.address "my address"
    t.phone "1231231234"
    t.seller_rate ".05"
    t.password_confirmation "yay1234"
    t.password "yay1234"
  end
end
