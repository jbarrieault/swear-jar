class AddColumnSenderToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :sender, :integer
  end
end
