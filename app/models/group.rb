class Group < ActiveRecord::Base
  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :triggers 
  has_many :violations
  has_many :tweets, through: :violations

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
    Message.closed_group(self) unless self.active == false
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

end
