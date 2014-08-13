class Tweet < ActiveRecord::Base
  belongs_to :user
  has_many   :violations
  has_many   :groups, through: :violations

  def violations_in_group(group)
    self.violations.where(group_id: group.id).first.triggers
  end
end
