class Violation < ActiveRecord::Base
  belongs_to :tweet
  belongs_to :group

  after_create :charge_the_user

  AMOUNT = 0.01

# https://api.venmo.com/v1/payments?user_id=1467765999271936020&amount=0.4&note=pleasedontwork&access_token=NujR7JM988nv4uzrgPKWPRFVs9nFErLc"

  def charge_the_user
    user = self.tweet.user
    admin_venmo_id = User.find(self.group.admin_id).venmo_id
    amount = AMOUNT
    note = URI.escape("I said something stupid on twitter")
    access_token = user.token
    url = "https://api.venmo.com/v1/payments?user_id=#{admin_venmo_id}&amount=#{amount}&note=#{note}&access_token=#{access_token}"
  end

end
