##
# Helper for notifications
module NotificationsHelper
  # Create notification for user of user_id as long as such user exists and corresponding notification isn't empty.
  def create_notification(user_id, post)
    user = User.find_by_id(user_id)
	if user.nil?
	  return nil
	else
	  if post == ''
        return 2
	  else
	    note_new = Notification.new
	    note_new.user_id = user_id
	    note_new.post = post
		  note_new.unread = 1
	    note_new.save  
	  end
	end
      return 1
  end

  
  # Build all unread notifications for current user
  def new_notification
    sum = 0
    user = current_user
	if user.nil?
	  return sum
	end
	  notification_all = Notification.all
	  notification_all.each do |note|
      if note.user_id == user.id
        if note.unread == 1
          sum = sum + 1
        end
      end
	  end
	  return sum
  end
end
