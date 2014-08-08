class GroupsController < ApplicationController

  def index
    @user = User.find(session[:user_id]) 
  end

  def show
    @group = Group.find(params[:id])
    @triggers = @group.triggers
  end

  def new
    @group = Group.new
    @users = User.all
  end

  def create
    @group = Group.new
    @group.name = params[:name] 
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
    @group.triggers = []
    @group.assign_triggers(params[:triggers]) # not needed, we don't permit this aymore?
    @group.users = []
    @group.assign_users(params[:user])
    redirect_to groups_path
  end

  def join
    @groups = Group.all
  end

  def join_groups
    @user = User.find(current_user)
    @user.join_groups(params[:groups])
    redirect_to user_path(current_user)
  end

  def close
    @group = Group.find(params[:group_id])
    @group.active = false if current_user.id == @group.admin_id 
    @group.save
    redirect_to closed_group_path(@group)
  end

  def closed
    @group = Group.find(params[:id])
    @group.amount = 2 #THIS IS SET TEMPORARILY, DELETE!!!
    @group.fund_name = "Party Fund" #THIS IS SET TEMPORARILY, DELETE!!!
  end

  def refund
    @group = Group.find(params[:group_id])
    if @group.refunded == false
      @group.amount = 2 #THIS IS SET TEMPORARILY, DELETE!!!
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
    @group.destroy if current_user.id == @group.admin_id 
    redirect_to user_path(current_user)
  end

end
