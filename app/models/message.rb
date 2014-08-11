class Message < ActiveRecord::Base
  belongs_to :user

  def viewed?
    self.view_count > 1 
  end

  def self.join_group(group, user)
    message = "#{user.name.capitalize} has joined #{group.name}"
    group.users.each do |u|
      u.messages.build(content: message).save unless u == user
    end
  end

  def self.user_leave
    # build along with AJAX groups page
  end

  def self.closed_group(group)
    message = "#{group.admin.name} has closed #{group.name}."
    group.users.each do |user|
      user.messages.build(content: message).save unless user == group.admin
    end
  end

  def self.refund(group)
    group.users.each do |user|
      refund_amt = '%.2f' % (user.group_balance(group) / 100.0)
      message = "You have been refunded $#{refund_amt} from #{group.name}."
      user.messages.build(content: message).save unless user == group.admin
    end
  end

  def self.delete_group(group)
    message = "#{group.admin.name} has deleted #{group.name}."
    group.users.each do |user|
      user.messages.build(content: message).save unless user == group.admin
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
