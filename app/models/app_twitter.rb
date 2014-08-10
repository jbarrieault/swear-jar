class AppTwitter

  def self.client
    @@client ||= Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['SJ_TWEETAPPKEY']
      config.consumer_secret = ENV['SJ_TWEETAPPSECRET']
      config.access_token = ENV['SJ_TWEETTOKEN']
      config.access_token_secret = ENV['SJ_TWEETTOKENSECRET']
    end
  end

  def self.tweet_to(message)
    self.client.update(message)
  end




end