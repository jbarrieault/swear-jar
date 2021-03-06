class MessagesController < ApplicationController
  before_action(:set_user)

  def index
    @messages = Message.increment_view_count(@user)
    @user = current_user
    @users = User.all
    gon.user_id = current_user.id
  end

  def destroy
    if params[:all]
      current_user.messages.destroy_all
    else
      @message = Message.find(params[:id])
      @message.destroy
    end
    render json: current_user
  end

  private

    def set_user
      @user = User.find(current_user.id)
    end
end
