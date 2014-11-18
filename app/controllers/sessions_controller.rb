class SessionsController < ApplicationController
  skip_before_filter :require_login, only: [:create, :destroy]
  skip_before_filter :venmo?, only: [:create, :destroy]

  def new
  end

  def create
    if auth_hash[:provider] == "twitter"
      image_url   = auth_hash[:info][:image].gsub("_normal", "")
      handle = auth_hash[:info][:nickname]
      @user = User.find_or_create_by(twitter_id: auth_hash[:uid], name: auth_hash[:info][:name])
      if @user
        @user.image_url = image_url
        @user.save
        unless @user.bookend
          @user.set_bookend
        end
         session[:user_id] = @user.id
         redirect_to user_path(current_user)
       end
    elsif auth_hash[:provider] == "venmo"
      current_user.venmo_id = auth_hash[:uid]
      current_user.token = auth_hash[:credentials][:token]
      current_user.save
      redirect_to user_path(current_user)
    end
  end

  def destroy
    reset_session
    redirect_to root_url
  end

  protected
    def auth_hash
      request.env['omniauth.auth']
    end
end
