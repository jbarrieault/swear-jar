class Trigger < ActiveRecord::Base
  belongs_to :group
  has_many :trigger_violations
  has_many :violations, through: :trigger_violations

  validates_presence_of :name
end
