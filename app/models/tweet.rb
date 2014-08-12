class Tweet < ActiveRecord::Base
  belongs_to :user
  has_many   :violations
  has_many   :groups, through: :violations

end
