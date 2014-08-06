class AddActiveColumnToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :active, :boolean, default: true
  end
end
