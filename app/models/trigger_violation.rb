class TriggerViolation < ActiveRecord::Base
  belongs_to :trigger
  belongs_to :violation


end