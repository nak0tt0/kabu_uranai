class UsersController < ApplicationController
  def show
    @user = User.find(session[:user_id]) if session[:user_id]
  end
end
