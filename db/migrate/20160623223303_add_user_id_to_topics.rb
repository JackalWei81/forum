class AddUserIdToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :user_id, :integer, :index => true
  end
end
