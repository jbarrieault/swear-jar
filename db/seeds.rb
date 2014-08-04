# group  = Group.create(name: "Flatiron School")
# group2 = Group.create(name: "Family")

# trigger  = Trigger.create(name: "App Academy")
# trigger2 = Trigger.create(name: "Shit")

# user  = User.create(name: "Jacob", twitter_id: 1, venmo_id: 1)
# user2 = User.create(name: "Amy", twitter_id: 2, venmo_id: 2)
# user3 = User.create(name: "Mitch", twitter_id: 3, venmo_id: 3)


# group.triggers << trigger
# group.triggers << trigger2

# group2.triggers << trigger2

# user.groups << group
# user.groups << group2

# user2.groups << group2
# user3.groups << group

user.tweets.build(content: "Heard of App Academy?").save
user.tweets.build(content: "Heard of Shit?").save



#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
