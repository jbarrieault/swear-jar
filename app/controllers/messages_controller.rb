class MessagesController < ApplicationController
  before_action(:set_user)

  def index
    @messages = Message.increment_view_count(@user)
    gon.user_id = current_user.id
  end

  def destroy
    if params[:message][:all]
      current_user.messages.destroy_all
      render json: current_user
    else
      @message = Message.find(params[:id])
      @message.destroy
      redirect_to user_messages_path
    end
  end

  private

    def set_user
      @user = User.find(current_user.id)
    end
end
