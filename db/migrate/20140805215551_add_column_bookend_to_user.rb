class AddColumnBookendToUser < ActiveRecord::Migration
  def change
    add_column :users, :bookend, :string
  end
end
