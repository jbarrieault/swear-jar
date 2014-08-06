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
    @group.assign_users(params[:user])
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
    @group.assign_triggers(params[:triggers])
    @group.users = []
    @group.assign_users(params[:user])
    redirect_to groups_path
  end

  def join
    @groups = Group.all
  end

  def join_groups
    @user = User.find(1)
    @user.join_groups(params[:groups])
  end

end
