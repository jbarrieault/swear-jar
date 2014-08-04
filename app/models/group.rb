class Group < ActiveRecord::Base
  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :triggers
  has_many :violations
  has_many :tweets, through: :violations

 



end
