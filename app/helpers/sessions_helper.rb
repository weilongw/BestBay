##
# Helper module for Sessions
module SessionsHelper
  # signs the given user into the site
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  # setter method in order to set the current user on the site to be the provided parameter
  def current_user=(user)
    @current_user = user
  end

  # fetch the current_user if it's already defined, otherwise, fetch it via the cookie
  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  # getter method to check if a user is signed in or not
  def signed_in?
    !current_user.nil?
  end

  # modifier to sign the current user out
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  # Authenticate login, otherwise renders error information
  def authenticate
    if !signed_in?
      render 'shared/error'
    end
  end
end
