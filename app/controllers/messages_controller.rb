class MessagesController < ApplicationController
  before_action(:set_user)

  def index
    
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    redirect_to user_messages_path
  end

  private

    def set_user
      @user = User.find(current_user.id)
    end
end
