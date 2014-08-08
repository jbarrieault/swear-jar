class User < ActiveRecord::Base
  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :tweets
  has_many :violations, through: :tweets

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

  def join_groups(groups)
    scan_tweets
    groups.each do |g|
      self.groups << Group.find(g) unless self.groups.include?(Group.find(g))
    end
  end

  def new_tweet_batch
    tweet_batch = self.class.twitter_client.user_timeline(self.twitter_id.to_i,
      {count: 40, include_rts: false}) 
    raw_tweets = tweet_batch.map { |t| t if t.id.to_i > self.bookend.to_i }.compact
    self.bookend = raw_tweets.first.id unless raw_tweets == []
    return raw_tweets
  end

  def scan_tweets
    groups = self.active_groups.includes(:triggers)

    new_tweet_batch.each do |raw_tweet|
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
            v.charge_the_user
          end
        end
      end
    end
  end

  def group_balance(group)
    self.violations.where(group_id: group.id).inject do |sum, v| 
      sum += v.amt_charged 
    end
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

end