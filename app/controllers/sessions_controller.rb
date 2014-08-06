class SessionsController < ApplicationController

    def new

    end

    def create
      if auth_hash[:provider] == "twitter"
        image_url = auth_hash[:info][:image].gsub("_normal", "")
        @user = User.find_or_create_by(twitter_id: auth_hash[:uid], name: auth_hash[:info][:name], image_url: image_url)
        if @user
          unless @user.bookend
            User.create_client
            @user.set_bookend
          end
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
