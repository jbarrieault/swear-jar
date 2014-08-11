class UsersController < ApplicationController
  skip_before_filter :venmo?, only: [:venmo]

  def show
    @user = User.find(params[:id])
  end

  def venmo
    
  end

end
