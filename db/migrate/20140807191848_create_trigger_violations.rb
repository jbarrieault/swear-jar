class CreateTriggerViolations < ActiveRecord::Migration
  def change
    create_table :trigger_violations do |t|
      t.integer :trigger_id
      t.integer :violation_id

      t.timestamps
    end
  end
end
