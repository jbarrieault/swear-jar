class AddColumnAmountToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :amount, :integer
  end
end
