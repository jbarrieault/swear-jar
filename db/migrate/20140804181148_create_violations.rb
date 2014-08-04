class CreateViolations < ActiveRecord::Migration
  def change
    create_table :violations do |t|
      t.integer :tweet_id
      t.integer :group_id

      t.timestamps
    end
  end
end
