class AddPurposeColumnToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :purpose, :string
  end
end
