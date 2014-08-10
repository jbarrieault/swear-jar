class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :view_count, default: 0
      t.string  :content
      t.integer :user_id

      t.timestamps
    end
  end
end
