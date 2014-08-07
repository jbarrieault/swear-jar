class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :require_login, :venmo?
  skip_before_filter :require_login, only: [:home]
  skip_before_filter :venmo?, only: [:home]

  helper_method def logged_in?
    !!current_user #double negation to convert to boolean
  end

  helper_method def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id] #memoized
  end

  def home

  end

  private

  def current_user=(user)
    @current_user = user
    session[:user_id] = user.nil? ? nil : user.id
  end

  def require_login
    unless logged_in?
      redirect_to root_path 
      flash[:notice] = "Please Log In" 
    end
  end

  def venmo?
    unless current_user.venmo_id
      redirect_to venmo_path
    end
  end

end



