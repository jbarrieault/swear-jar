class Group < ActiveRecord::Base
  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :triggers 
  has_many :violations
  has_many :tweets, through: :violations

  def self.amounts
    [["$0.01", 1], ["$0.10", 10], ["$0.25", 25], ["$0.50", 50], ["$1.00", 100]]
  end

  def admin
    User.find(self.admin_id)
  end

  def assign_triggers(triggers)
    triggers = triggers.map(&:strip).uniq.reject {|t| t.empty? }
    triggers.each do |t|
      self.triggers.build(name: t).save
    end
  end

  def assign_users(users)
    users.each do |u|
      self.users << User.find(u)
    end
  end

  def dollar_balance
    self.balance/100.0
  end  

  def dollar_amount
    self.amount/100.0
  end

  def status
    self.active == false ? "closed" : "open"
  end

  def refund_all
    self.users.each do |user|
      payment_due = user.group_balance(self)
      refund_user(user, payment_due) unless user.id == self.admin_id
    end
    Message.admin_event(self, "closed") unless self.active == false
    Message.refund(self)
    self.refunded = true
    self.active = false
    self.save
  end

  def refund_user(user, payment_due)
    admin_token = User.find(self.admin_id).token
    note = "Swear-jar refund for #{self.name}"
    amount = payment_due/100.0

    conn = Faraday.new(:url => 'https://api.venmo.com') do |faraday|
        faraday.request  :url_encoded 
        faraday.response :logger
        faraday.adapter  Faraday.default_adapter
      end

    response = conn.post '/v1/payments', { user_id: user.venmo_id, amount: amount, note: note, access_token: admin_token}
  end

  def most_used_triggers
    data = []
    labels = []
    self.triggers.each do |trigger|
      labels << trigger.name
      data << trigger.violations.count
    end
    return [data, labels]
  end

  def violations_over_time
    data = Hash.new(0)
    days = [Date.today - 6, Date.today - 5, Date.today - 4, Date.today - 3, Date.today - 2, Date.today - 1, Date.today ]

    violations = self.violations
    days.each do |day|
        violation_count = violations.select {|v| v.created_at.to_date == day}.count
        data[day.strftime('%A')] = violation_count
    end

    return [data.values, data.keys]
  end

  def violations_per_user
    data = []
    labels = []

    self.users.each do |user|
      labels << user.name
      data << user.violations.where(:group_id => self.id).count
    end

    return [data, labels]
  end

end
