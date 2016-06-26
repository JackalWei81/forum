class RemoveColumnToUsers < ActiveRecord::Migration
  def change
    remove_column :users, :bio
  end
end
