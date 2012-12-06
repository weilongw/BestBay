# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification do
    post "MyString"
    user_id 1
    post_time "2012-09-27 23:16:46"
  end
end
