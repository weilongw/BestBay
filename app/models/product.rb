## == Schema Information
#
# Table name: products
#
#  id                 :integer          not null, primary key
#  category_id        :integer
#  owner_id           :integer
#  current_bid_id     :integer
#  product_name       :string(255)
#  description        :string(255)
#  count_click        :integer
#  current_bid_price  :decimal(, )
#  buy_out_price      :decimal(, )
#  start_price        :decimal(, )
#  end_date           :datetime
#  product_rate       :decimal(, )
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#

class Product < ActiveRecord::Base

  attr_accessible :created_at, :closed, :buy_out_price, :category_id, :count_click, :current_bid_id, :current_bid_price, :description, :end_date, :id, :owner_id, :product_name, :product_rate, :start_price, :photo, :photo_file_name, :photo_content_type, :photo_file_size, :rating

  default_scope order('count_click DESC')

  #validate that all the fields below are present
  validates  :product_name, :presence=>true, :length=>{:maximum=>50}
  validates  :start_price, :presence=>true
  validates  :description, :presence=>true
  validates  :category_id, :presence=>true
  validates  :owner_id,    :presence=>true
  validates_numericality_of :start_price

  belongs_to :category
  #product image that is displayed should be the thumbnail version
  has_attached_file :photo, :styles => {:small => "120x120>", :large => "400x400>" }

  #make sure a photo is present, less than 5 mb, and is of a certain content type
  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/gif', 'image/png']

  validate :start_must_be_before_end_time

  has_many :bids, dependent: :destroy
  has_many :users, through: :bids

  # A heler function used to test whether current time is before a product's end date or not
  def start_must_be_before_end_time
    if (self.created_at.nil? && Time.now.utc > self.end_date)
      errors.add(:end_date,"is not valid,please enter a valid one" )
      return false
    end
    return true
  end
end
