class User < ActiveRecord::Base
  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :tweets
  has_many :violations, through: :tweets
  has_many :messages

  attr_encrypted :token, key: ENV['ATTR_SECRET_KEY']

  def self.twitter_client
    @@client ||= Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWEETAPPKEY']
      config.consumer_secret = ENV['TWEETAPPSECRET']
      config.access_token = ENV['TWEETTOKEN']
      config.access_token_secret = ENV['TWEETTOKENSECRET']
    end
  end

  def self.create_with_omniauth(info)
    create(name: info['name'])
  end

  def set_bookend 
    most_recent  = self.class.twitter_client.user_timeline(self.twitter_id.to_i, {count: 1, include_rts: false})
    self.bookend = most_recent == [] ? 0 : most_recent.first.id #works, in theory
    self.save
  end

  def join_group(group)
    scan_tweets

    unless self.groups.include?(group)
      self.groups << group 
      Message.join_group(group, self) 
    end
  end

  def leave_group(group)
    scan_tweets

    if self.groups.include?(group)
      membership = UserGroup.find_by(user_id: self.id, group_id: group.id)
      # Message.leave_group(group, self)
      membership.destroy
    end
  end

  def new_tweet_batch
    tweet_batch = self.class.twitter_client.user_timeline(self.twitter_id.to_i,
      {count: 40, include_rts: false}) 
    raw_tweets = tweet_batch.map { |t| t if t.id.to_i > self.bookend.to_i }.compact
    self.bookend = raw_tweets.first.id unless raw_tweets == []
    self.save
    return raw_tweets
  end

  def scan_tweets
    valid = self.venmo_token_valid?
    groups = self.active_groups.includes(:triggers)
    new_tweet_batch.reverse.each do |raw_tweet|
      groups.each do |group|
        violations_created = false
        group.triggers.each_with_index do |trigger, i|
          if raw_tweet.full_text.downcase.include?(trigger.name.downcase) 
            tweet = Tweet.find_or_create_by(content: raw_tweet.full_text)

            self.tweets << tweet unless self.tweets.include?(tweet)
            v = Violation.find_by(tweet_id: tweet.id, group_id: group.id)
            if v
              v.triggers << trigger
              v.save
            else
              violations_created = true
              v = Violation.create(tweet_id: tweet.id, group_id: group.id)
              v.triggers << trigger
              v.save
            end
          end
          if violations_created && i == group.triggers.length - 1 
            v = Violation.find_by(tweet_id: Tweet.find_by(content: raw_tweet.full_text).id, group_id: group.id)
            if !(valid)
              v.amt_charged = 0
              v.save
            elsif self.over_limit?
              binding.pry
              v.amt_charged = 0
              v.save
            else
              v.amt_charged = group.amount
              v.save
              v.charge_the_user
              # group.balance += group.amount
              # group.save
            end
          end
        end
      end
    end
  end

  def group_balance(group)
    balance = 0
    self.violations.where(group_id: group.id).each do |v| 
      balance += v.amt_charged 
    end
    return balance
  end

  def admin?(group)
    !!(group.admin_id == self.id)
  end

  def violation_count(group_id)
    self.violations.where(group_id: group_id).count
  end

  def admin_groups
    self.groups.where(admin_id: id)
  end

  def admin_groups_active
    self.groups.where(admin_id: id, active: true)
  end

  def admin_groups_closed
    self.groups.where(admin_id: id, active: false)
  end

  def user_groups
    self.groups.where.not(admin_id: id)
  end

  def active_groups
    self.groups.where(active: true)
  end

  def rolling_monthly_balance
    balance = 0
    self.violations.where('violations.created_at >= ?', 1.month.ago).each do |violation|
      balance += violation.amt_charged if violation.amt_charged
    end
    return balance
  end

  def total_balance
    balance = 0
    self.violations.each do |violation|
      balance += violation.amt_charged 
    end
    return balance
  end

  def over_limit?
    !!(rolling_monthly_balance >= 2000)
  end

  def venmo_token_valid?
    return false if self.encrypted_token == nil

    access_token = self.token
    conn = Faraday.new(:url => 'https://api.venmo.com') do |faraday|
        faraday.request  :url_encoded 
        faraday.response :logger
        faraday.adapter  Faraday.default_adapter
      end

    response = conn.get '/v1/me', { access_token: access_token}

    if response.status == 200 
        return true
    else
        self.encrypted_token = nil
        self.save
        return false
    end
  end

  def new_message_count
    count = self.messages.select { |message| message.view_count < 2 }.count
    count = nil if count == 0
    count
  end

  def membership(group)
    self.groups.include?(group) ? "member" : "nonmember"
  end

  def member?(group)
    self.groups.include?(group) ? true : false
  end



end