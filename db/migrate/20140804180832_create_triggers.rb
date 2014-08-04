class CreateTriggers < ActiveRecord::Migration
  def change
    create_table :triggers do |t|
      t.string :name
      t.integer :group_id

      t.timestamps
    end
  end
end
