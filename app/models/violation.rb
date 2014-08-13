class Violation < ActiveRecord::Base
  belongs_to :tweet
  belongs_to :group
  has_many :trigger_violations
  has_many :triggers, through: :trigger_violations

  def charge_the_user
    user = self.tweet.user
    admin = User.find(self.group.admin_id)
    words = self.triggers.pluck(:name).join(" and ")
    AppTwitter.tweet_to(build_message(user, words))
    
    unless user.id == admin.id
      admin_venmo_id = admin.venmo_id
      amount = self.group.dollar_amount
      time = self.tweet.created_at.strftime("%I:%M:%S %p").gsub(":", " ")
      note = "I said #{words} on twitter around #{time} UTC. auto-payment via swear-jar"
      access_token = user.token

      conn = Faraday.new(:url => 'https://api.venmo.com') do |faraday|
        faraday.request  :url_encoded 
        faraday.response :logger
        faraday.adapter  Faraday.default_adapter
      end

      response = conn.post '/v1/payments', { user_id: admin_venmo_id, amount: amount, note: note, access_token: access_token}
    end
    self.group.balance += (self.group.amount).to_i
    self.group.save
  end

  def build_message(user, words)
    [
      "Busted! @#{user.screen_name}, we caught you saying #{words}! Thanks for using #swearjar",
      "Got ya! @#{user.screen_name}, we noticed you said #{words}! Thanks for using #swearjar",
      "Hey! @#{user.screen_name}, you said #{words}! Time to pay up! Thanks for using #swearjar",
      "Whoa there. @#{user.screen_name}, take easy on the #{words}... Thanks for using #swearjar",
      "Dude, @#{user.screen_name}. You should really stop saying #{words}. Thanks for using #swearjar",
      "Seriously!? @#{user.screen_name}, you said #{words.upcase}!? That's gonna cost you a pretty penny! Thanks for using #swearjar",
      "Dear @#{user.screen_name}, I am shocked by your lavish use of #{words}. Thanks for using #swearjar"
    ].sample
  end

end