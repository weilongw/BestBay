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

require 'spec_helper'

describe Notification do
  before do
    @notification = Notification.new(post: 'You have a message')
  end
  subject (@notification)

  it { should respond_to(:post)}
  it { should respond_to(:created_at)}
  it { should respond_to(:unread)}
end
