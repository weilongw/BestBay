## == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  first_name      :string(255)
#  last_name       :string(255)
#  address         :string(255)
#  phone           :string(255)
#  seller_rate     :decimal(, )
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#
class User < ActiveRecord::Base
  attr_accessible :address, :email, :first_name, :last_name, :password, :phone, :seller_rate, :password_confirmation, :rating
  has_secure_password
  
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  #ensure that a given email is properly formatted
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness:  { case_sensitive: false }

  #ensure that the following fields have a maximum length
  validates :address, presence: true, length: { maximum: 150 }
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }

  #validate phone numbers to be of the form 1231231234 or 123-123-1234
  VALID_PHONE_REGEX = /\(?[0-9]{3}\)?[-. ]?[0-9]{3}[-. ]?[0-9]{4}/ 
  validates :phone, presence: true, length: { maximum: 12 }, format: { with: VALID_PHONE_REGEX }

  #ensure a proper password is typed
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  has_many :bids, dependent: :destroy
  has_many :products, through: :bids
  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
