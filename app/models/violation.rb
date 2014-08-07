class Violation < ActiveRecord::Base
  belongs_to :tweet
  belongs_to :group
  has_many :trigger_violations
  has_many :triggers, through: :trigger_violations

  AMOUNT = 0.01

  def charge_the_user
    user = self.tweet.user
    admin = User.find(self.group.admin_id)
    unless user.id == admin.id
      admin_venmo_id = admin.venmo_id
      amount = AMOUNT
      words = self.triggers.pluck(:name).join(" and ")
      time = self.tweet.created_at.strftime("%I:%M:%S %p")
      note = "I said #{words} on twitter around #{time}"
      access_token = user.token
      
      conn = Faraday.new(:url => 'https://api.venmo.com') do |faraday|
        faraday.request  :url_encoded 
        faraday.response :logger
        faraday.adapter  Faraday.default_adapter
      end

      response = conn.post '/v1/payments', { user_id: admin_venmo_id, amount: amount, note: note, access_token: access_token}

      #parsed = Oj.load(response.body, symbol_keys: true)
    end
    self.group.balance += (AMOUNT*100).to_i
    self.group.save
  end

end