class User < ActiveRecord::Base
  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :tweets
  has_many :violations, through: :tweets

  @@client = nil

  def self.create_client
    @@client = Twitter::REST::Client.new do |config|
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
    most_recent  = @@client.user_timeline(self.twitter_id.to_i, {count: 1, include_rts: false})
    self.bookend = most_recent == nil ? 0 : most_recent.first.id #works, in theory
    self.save
  end


  def join_groups(groups)
    scan_tweets
    groups.each do |g|
      self.groups << Group.find(g) unless self.groups.include?(Group.find(g))
    end
  end

  def new_tweet_batch
    tweet_batch = @@client.user_timeline(self.twitter_id.to_i,
      {count: 40, include_rts: false}) 
    tweets = tweet_batch.map { |t| t if t.id.to_i > self.bookend.to_i }.compact
    self.bookend = tweets.first.id
    return tweets
  end

  def scan_tweets
    groups = self.groups.includes(:triggers)

    new_tweet_batch.each do |raw_tweet|
      groups.each do |group|
        group.triggers.each do |trigger|
          if raw_tweet.full_text.downcase.include?(trigger.name.downcase) 
            tweet = Tweet.find_or_create_by(content: raw_tweet.full_text)

            self.tweets << tweet unless self.tweets.include?(tweet)
            Violation.find_or_create_by(tweet_id: tweet.id, group_id: group.id)
          end
        end
      end
    end
  end


  def violation_count(group_id)
    self.violations.where(group_id: group_id).count
  end

end