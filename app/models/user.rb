class User < ActiveRecord::Base
  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :tweets
  has_many :violations, through: :tweets

  # scan_tweets every 10 minutes
  def scan_tweets
    raw_tweets = ["App Academy...Sucks!", "Shit man", "When is ice cream time?"]
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



  # iterate through each tweet and look for trigger words
  # if tweet contains trigger words, create a violation with tweet.user_id

end
