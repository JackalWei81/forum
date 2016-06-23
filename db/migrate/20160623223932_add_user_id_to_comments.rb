class AddUserIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :user_id, :integer, :index => true
  end
end
