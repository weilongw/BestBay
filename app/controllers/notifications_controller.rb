##
# Controller to handle all the notifications displayed in our "inbox"
class NotificationsController < ApplicationController

  #method creates a Notification based on the passed parameters
  #* if the result is null, an invalid notification was created
  #* if the parameters were invalid, an invalid notification was created
  #* otherwise, a proper notification is created

  def create
    respond_to do |format|
      format.html {
	  
	    noti_id = params[:notification]["id"]
		read = Notification.find_by_id(params[:notification]["id"])
		if read.nil?
			result = create_notification(params[:notification]["user_id"], params[:notification]["post"])
			if result.nil?
			  flash[:fail] = "Notification Failed, check user ID!"
			  redirect_to '/notification'
			else
			  if result == 2
				flash[:fail] = "Notification failed. Empty post!"
				redirect_to '/notification'
			  else
				flash[:success] = "Notification Posted!"
				redirect_to '/notification'
			  end
			end
		else
			read.unread = 0
			read.save
			redirect_to '/notification'
		end
		
		
	  }
	  
    end
    

  end

end
