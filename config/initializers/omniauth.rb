Rails.application.config.middleware.use OmniAuth::Builder do
    provider :twitter, ENV['TWEETAPPKEY'], ENV['TWEETAPPSECRET']
end