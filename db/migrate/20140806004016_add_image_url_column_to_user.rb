class AddImageUrlColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :image_url, :string
  end
end
