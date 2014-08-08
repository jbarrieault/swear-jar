class AddRefundedColumnToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :refunded, :boolean, default: false
  end
end
