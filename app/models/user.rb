TWEETAPPKEY = "hGuIGM9vFCTtVm4DmPCX9RF3E"
TWEETAPPSECRET = "jxFAyFQNYLW24jmKFO1YkgpBW8XwzH4337XymUEGtf7zxZYiFb"
TWEETTOKEN = "2604285230-AV99szaeXcEkDxtmpTExERHGmwNmq3DmWraPqF5"
TWEETTOKENSECRET = "i6gfbMymtyAiU1PeOK5A7UYx58ts5sExsON8SmsPADRGQ"
# jacob = User.new(name: "jacob", twitter_id: 1961118786 )


class User < ActiveRecord::Base
  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :tweets
  has_many :violations, through: :tweets

  attr_accessor :last_batch_tweet_id, :client

  def init
    create_client

    # what to do when user joins new group? 
    # need to set a new @last_batch_tweet_id starting at
    # or after user joined the new group
    self.last_batch_tweet_id = @client.user_timeline(self.twitter_id, {count: 1, include_rts: false}).first.id
    return self
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
    groups.each do |g|
      self.groups << Group.find(g) unless self.groups.include?(Group.find(g))
    end
  end

  def raw_tweets
    tweet_batch = new_tweet_batch
    binding.pry
    self.last_batch_tweet_id = tweet_batch.first.id unless tweet_batch.empty?
    return tweet_batch
  end

  def new_tweet_batch
    tweet_batch = self.client.user_timeline(self.twitter_id,
      {count: 40, include_rts: false, max_id: self.last_batch_tweet_id})

    return tweet_batch.map! { |t| t.full_text unless t.id <= self.last_batch_tweet_id }.compact!
  end

  # scan_tweets every 20? minutes
  def scan_tweets
    #raw_tweets = ["App Academy...Sucks!", "Shit man", "When is ice cream time?"]
    groups = self.groups.includes(:triggers)

    raw_tweets.each do |raw_tweet|
      groups.each do |group|
        group.triggers.each do |trigger|
          if raw_tweet.downcase.include?(trigger.name.downcase) # raw_tweet[:content] ?
            tweet = Tweet.find_or_create_by(content: raw_tweet, user_id: self.id) #check API for key
            Violation.create(tweet_id: tweet.id, group_id: group.id)
          end
        end
      end
    end

  end

  def self.create_from_omniauth(auth_hash)
    self.create(provider: auth_hash[:provider],
                uid: auth_hash[:uid],
                name: auth_hash[:info][:name])
  end


end
