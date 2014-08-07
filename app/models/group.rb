class Group < ActiveRecord::Base
  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :triggers
  has_many :violations
  has_many :tweets, through: :violations

  def assign_triggers(triggers)
    triggers = triggers.split(",").map(&:strip).uniq
    triggers.each do |t|
      self.triggers.build(name: t).save
    end
  end

  def assign_users(users)
    users.each do |u|
      self.users << User.find(u)
    end
  end

  def activate(user)
    self.active = false if user.id == self.admin_id 
  end

end
