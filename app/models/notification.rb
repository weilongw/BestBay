# == Schema Information
#
# Table name: notifications
#
#  id         :integer          not null, primary key
#  post       :string(255)
#  user_id    :integer
#  unread     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

##
# Class represent the notification model: representation of the notification a user can receive
class Notification < ActiveRecord::Base
  attr_accessible :post, :unread, :user_id, :created_at
  default_scope order: 'notifications.created_at DESC'
end
