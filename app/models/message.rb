class Message < ActiveRecord::Base
  belongs_to :user

  def viewed?
    self.view_count > 1 
  end

  # refactor of join_group & leave_group
  def self.user_event(group, user, action)
    message = "#{user.name.capitalize} has #{action} #{group.name}"
    group.users.each do |u|
      u.messages.build(content: message, sender: user.id).save unless u == user
    end
  end

  # refactor of delete_group & close_group
  def self.admin_event(group, action)
    message = "#{group.admin.name} has #{action} #{group.name}."
    group.users.each do |user|
      user.messages.build(content: message, sender: group.admin.id).save unless user == group.admin
    end
  end

  def self.refund(group)
    group.users.each do |user|
      refund_amt = '%.2f' % (user.group_balance(group) / 100.0)
      message = "You have been refunded $#{refund_amt} from #{group.name}."
      user.messages.build(content: message, sender: group.admin.id).save unless user == group.admin
    end
  end


  def self.increment_view_count(user) 
    user.messages.each do |message|
      message.view_count += 1 unless message.view_count > 1 
      message.save
    end
  end

  def self.increment_viewed_messages(user)
    user.messages.each do |message|
      message.view_count += 1 if message.view_count == 1
      message.save
    end
  end


end
