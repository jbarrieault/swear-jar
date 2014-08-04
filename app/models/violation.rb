class Violation < ActiveRecord::Base
  belongs_to :tweet
  belongs_to :group
end
