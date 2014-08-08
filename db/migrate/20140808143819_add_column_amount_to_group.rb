class AddColumnAmountToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :amount, :integer, :default => 0
  end
end
