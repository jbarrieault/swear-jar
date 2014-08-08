class RemoveColumnProviderFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :provider 
  end
end
