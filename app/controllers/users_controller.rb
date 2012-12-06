require 'will_paginate/array'
##
# User controller, which has the following methods:
class UsersController < ApplicationController
  before_filter :authenticate,  :only => [:show,:profile,:selling,:buying, :notification, :update]
  # Create(signup) a new user
  def new
    @user = User.new
  end
  
  # List a particular user according to user id
  def show
    @user = User.find(params[:id])
  end
  
  # Emit a green notification if signup successfully, or redirect back to signup page
  def create
    @user = User.new(params[:user])
    if @user.save
	  sign_in @user
	  flash[:success] = "Register Success!"
      redirect_to '/'
    else
      render 'new'
    end
  end
  
  # List current user's profile page.
  def profile
    @user = current_user
  end
  
  # List current user's selling products
  def selling
    @user = current_user
	  @product_all = Product.all
  end

  # List all the products that current user is bidding on
  def buying
    @bid_all = Bid.all
	  @product_all = Product.all
	  @user = current_user
  end
  
  # Support showing 5 pending notifications per page.
  def notification
    @user = current_user
    @notification_all = Notification.find_all_by_user_id(@user.id)
    @notification_all = @notification_all.paginate( :per_page => 5, :page => params[:page])
    @notification = Notification.new
    @read = Notification.new
  end
  
  # Update current user's profile, on sucess it renders the new profile page and emitts a green flash.
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to root_path
    else
      render 'profile'
    end
  end
  
end

