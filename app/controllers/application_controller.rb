##
# Default created Application Controller
class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include NotificationsHelper
  include ProductsHelper
end
