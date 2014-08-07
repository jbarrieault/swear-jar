class Violation < ActiveRecord::Base
  belongs_to :tweet
  belongs_to :group

  after_create :charge_the_user

  AMOUNT = 0.01

  def charge_the_user
    user = self.tweet.user
    admin_venmo_id = User.find(self.group.admin_id).venmo_id
    amount = AMOUNT
    note = URI.escape("I said something stupid on twitter")
    access_token = user.token
    
    conn = Faraday.new(:url => 'https://api.venmo.com') do |faraday|
      faraday.request  :url_encoded 
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    response = conn.post '/v1/payments', { user_id: admin_venmo_id, amount: amount, note: note, access_token: access_token}

    #parsed = Oj.load(response.body, symbol_keys: true)
  end


end