namespace :drop do
  desc "Destroys all users" 
  task :users => :environment do
    User.destroy_all
  end

    desc "Destroys all" 
  task :all => :environment do
    User.destroy_all
    Group.destroy_all
    UserGroup.destroy_all
    Violation.destroy_all
    Tweet.destroy_all
    Trigger.destroy_all
  end
end