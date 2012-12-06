##
# Controller to handle sessions
class SessionsController < ApplicationController
  # method initializes a new instance of the SessionsControllers
  def new
  end

  #method creates a new session based upon the user email address entered
  #If the user is valid and has been authenticated, the user will be signed in
  #Otherwise, there is an error and a notification will be flashed
  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to '/home'
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  #modifier to destroy the current user session and redirect the site back to the home page
  def destroy
    sign_out
    redirect_to root_url
  end

end
