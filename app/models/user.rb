# TWEETAPPKEY = "oPifycUU3xuvVdi8ImqG8TxdP"
# TWEETAPPSECRET = "m0QhdE7oHwN5IAH3uDzw6nmScJ7916KsdP1ugJaxwpmltnJmgU"
# TWEETTOKEN = "216539188-7lK5XMLAa2eVqaKnVrl89M1pCf6FhCb3y0A8Hpds"
# TWEETTOKENSECRET = "Tg6W5MgJD60oWOU3C8Mgeu7KmExwbWhSlQggX8dtCnwKZ"
# jacob = User.new(name: "jacob", twitter_id: 1961118786 )

class User < ActiveRecord::Base
  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :tweets
  has_many :violations, through: :tweets

  attr_accessor :book_end, :client

  TWEETAPPKEY = "oPifycUU3xuvVdi8ImqG8TxdP"
  TWEETAPPSECRET = "m0QhdE7oHwN5IAH3uDzw6nmScJ7916KsdP1ugJaxwpmltnJmgU"
  TWEETTOKEN = "216539188-7lK5XMLAa2eVqaKnVrl89M1pCf6FhCb3y0A8Hpds"
  TWEETTOKENSECRET = "Tg6W5MgJD60oWOU3C8Mgeu7KmExwbWhSlQggX8dtCnwKZ"

  # call @user.scan_tweets RIGHT before adding user to a new group
  # Call @user.init in sessions controller 
  def init  
    create_client

    set_book_end
    self
  end

  def create_client
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = TWEETAPPKEY
      config.consumer_secret = TWEETAPPSECRET
      config.access_token = TWEETTOKEN
      config.access_token_secret = TWEETTOKENSECRET
    end
  end

  def set_book_end 
    most_recent   = @client.user_timeline(self.uid.to_i, {count: 1, include_rts: false})
    self.book_end = most_recent == nil ? 0 : most_recent.first.id #works, in theory
  end

  def ten_tweets
    @client.user_timeline(self.uid.to_i, {count: 10, include_rts: false})
  end

  def create_client
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = TWEETAPPKEY
      config.consumer_secret = TWEETAPPSECRET
      config.access_token = TWEETTOKEN
      config.access_token_secret = TWEETTOKENSECRET
    end
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
    set_book_end unless tweet_batch.nil?
    return tweet_batch
  end

  def new_tweet_batch
    tweet_batch = self.client.user_timeline(self.uid.to_i,
      {count: 40, include_rts: false}) #is including retweets anyways, or favorites?
    return tweet_batch.map! { |t| t if t.id > self.book_end }.compact!
  end

  # scan_tweets every 20? minutes
  def scan_tweets
    #raw_tweets = ["App Academy...Sucks!", "Shit man", "When is ice cream time?"]
    groups = self.groups.includes(:triggers)

    raw_tweets.each do |raw_tweet|
      groups.each do |group|
        group.triggers.each do |trigger|
          
          if raw_tweet.full_text.downcase.include?(trigger.name.downcase) 
            binding.pry
            tweet = Tweet.find_or_create_by(content: raw_tweet.full_text) #, user_id: self.id
            self.tweets << tweet
            Violation.create(tweet_id: tweet.id, group_id: group.id)
          end
        end
      end
    end
    return self

  end

  def self.create_from_omniauth(auth_hash)
    self.create(provider: auth_hash[:provider],
                uid: auth_hash[:uid],
                name: auth_hash[:info][:name])
  end


end
