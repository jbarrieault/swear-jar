class SessionsController < ApplicationController

    def new

    end

    def create
      if auth_hash[:provider] == "twitter"
        @user = User.find_or_create_by(twitter_id: auth_hash[:uid], name: auth_hash[:info][:name])
        if @user
           session[:user_id] = @user.id
           redirect_to user_path(current_user)
         end
      elsif auth_hash[:provider] == "venmo"
        current_user.venmo_id = auth_hash[:uid]
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
