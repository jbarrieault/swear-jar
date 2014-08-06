Rails.application.config.middleware.use OmniAuth::Builder do
    provider :twitter, ENV['TWEETAPPKEY'], ENV['TWEETAPPSECRET']
    provider :venmo, ENV['VENMO_CLIENT_ID'], ENV['VENMO_CLIENT_SECRET'], scope: "access_profile,make_payments", response_type: "code"
end