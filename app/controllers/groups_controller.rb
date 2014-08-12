class GroupsController < ApplicationController

  def index
    @groups = Group.where(active: true).includes(:triggers)
    @user   = current_user
  end

  def show
    @group = Group.find(params[:id])
    @triggers = @group.triggers
    @membership = current_user.membership(@group)

    @trigger_data, @trigger_labels = @group.most_used_triggers[0], @group.most_used_triggers[1]
    @violation_data, @violation_labels = @group.violations_over_time[0], @group.violations_over_time[1]
    @user_data, @user_labels  = @group.violations_per_user[0], @group.violations_per_user[1]

    gon.trigger_labels = @trigger_labels
    gon.trigger_data   = @trigger_data

    gon.violation_labels = @violation_labels
    gon.violation_data   = @violation_data 

    gon.user_labels = @user_labels
    gon.user_data   = @user_data

  end

  def new
    @group = Group.new
    @users = User.all
    @amounts = Group.amounts
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
    Message.admin_event(@group, "closed")

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
    Message.admin_event(@group, "deleted")
    @group.destroy if current_user.id == @group.admin_id 
    redirect_to user_path(current_user)
  end

end
