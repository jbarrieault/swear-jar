class MessagesController < ApplicationController
  before_action(:set_user)

  def index
    
  end

  private

    def set_user
      @user = User.find(current_user.id)
    end
end
