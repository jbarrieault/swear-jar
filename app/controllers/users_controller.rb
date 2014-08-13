class UsersController < ApplicationController
  skip_before_filter :venmo?, only: [:venmo]

  def show
    @user = User.find(params[:id])
    @latest_violation = @user.violations.last
    if @latest_violation
      @latest_violation_content = @latest_violation.tweet.content
    else
      @latest_violation_content = "You don't have any violations! What are you doing with your life?"
    end
  end

  def venmo
    
  end

end
