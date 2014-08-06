class User < ActiveRecord::Base
  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :tweets
  has_many :violations, through: :tweets

  attr_accessor :client

  # call @user.scan_tweets RIGHT before adding user to a new group
  # Call @user.init in sessions controller 
  def init  
    create_client
    update_bookend
    self
  end

  def create_client
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWEETAPPKEY']
      config.consumer_secret = ENV['TWEETAPPSECRET']
      config.access_token = ENV['TWEETTOKEN']
      config.access_token_secret = ENV['TWEETTOKENSECRET']
    end
  end

  def update_bookend 
    most_recent  = @client.user_timeline(self.twitter_id.to_i, {count: 1, include_rts: false})
    self.bookend = most_recent == nil ? 0 : most_recent.first.id #works, in theory
    self.save
  end


  def join_groups(groups)
    #NEED TO SCAN TWEETS ON THIS LINE
    scan_tweets
    groups.each do |g|
      self.groups << Group.find(g) unless self.groups.include?(Group.find(g))
    end
  end

  def raw_tweets
    tweet_batch = new_tweet_batch
    update_bookend unless tweet_batch.nil?
    return tweet_batch
  end

  def new_tweet_batch
    tweet_batch = self.client.user_timeline(self.twitter_id.to_i,
      {count: 40, include_rts: false}) 
    return tweet_batch.map! { |t| t if t.id > self.bookend }.compact!
  end

  def scan_tweets
    groups = self.groups.includes(:triggers)

    raw_tweets.each do |raw_tweet|
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
    return self
  end

  def self.create_with_omniauth(info)
    create(name: info['name'])
  end

  def violation_count(group_id)
    self.violations.where(group_id: group_id).count
  end


end