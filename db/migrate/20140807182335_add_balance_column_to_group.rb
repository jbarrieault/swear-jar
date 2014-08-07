class AddBalanceColumnToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :balance, :integer, default: 0
  end
end
