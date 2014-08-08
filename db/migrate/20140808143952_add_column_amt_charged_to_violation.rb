class AddColumnAmtChargedToViolation < ActiveRecord::Migration
  def change
    add_column :violations, :amt_charged, :integer
  end
end
