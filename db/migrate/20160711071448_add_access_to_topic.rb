class AddAccessToTopic < ActiveRecord::Migration
  def change
    add_column :topics, :access, :integer
  end
end
