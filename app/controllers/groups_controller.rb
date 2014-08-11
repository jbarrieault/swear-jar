class GroupsController < ApplicationController

  def index
    @groups = Group.where(active: true).includes(:triggers)
    @user   = current_user
  end

  def show
    @group = Group.find(params[:id])
    @triggers = @group.triggers
    @membership = current_user.membership(@group)
  end

  def new
    @group = Group.new
    @users = User.all
    @amounts = [["$0.01", 1], ["$0.10", 10], ["$0.25", 25], ["$0.50", 50], ["$1.00", 100]]
  end

  def create
    @group = Group.new
    @group.name = params[:name] 
    @group.purpose = params[:purpose] 
    @group.amount = params[:amount].to_i unless params[:amount].to_i > 100
    @group.assign_triggers(params[:triggers])
    current_user.scan_tweets
    @group.users << current_user
    @group.admin_id = session[:user_id]
    @group.save
    redirect_to groups_path
  end

  def edit
    @group = Group.find(params[:id])
    @users = User.all
  end

  def update
    @group = Group.find(params[:id])
    @group.name = params[:name] 
    @group.purpose = params[:purpose] 
    @group.save
    redirect_to groups_path
  end

  def join_group
    @user = current_user
    @group = Group.find(params[:group][:id])
    @user.join_group(@group)

    respond_to do |format|
      format.json { render json: @user }
      format.html { redirect_to group_path(@group)}
    end
  end

  def leave_group
    @user = current_user
    @group = Group.find(params[:group][:id])
    @user.leave_group(@group)
    
    respond_to do |format|
      format.json { render json: @user }
      format.html { redirect_to group_path(@group)}
    end
  end

  def close
    @group = Group.find(params[:group_id])
    @group.active = false if current_user.id == @group.admin_id 
    @group.save
    Message.closed_group(@group)

    respond_to do |format|
      format.json { render json: @group }
      format.html { redirect_to closed_group_path(@group) }
    end
  end

  def closed
    @group = Group.find(params[:id])
  end

  def refund
    @group = Group.find(params[:group_id])
    if @group.refunded == false
      @group.refund_all
      @group.save
      flash[:notice] = "You have issued a refund to each member of the group"
      redirect_to group_path
    else
      flash[:notice] = "This group has already been issued a refund" 
      redirect_to group_path
    end
  end

  def destroy
    @group = Group.find(params[:group_id])
    Message.delete_group(@group)
    @group.destroy if current_user.id == @group.admin_id 
    redirect_to user_path(current_user)
  end

end
