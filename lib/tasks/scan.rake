namespace :tweets do
  desc "Scans all tweets for all users" 
  task :scan => :environment do
    User.all.each do |user|
      user.scan_tweets
    end
  end
end