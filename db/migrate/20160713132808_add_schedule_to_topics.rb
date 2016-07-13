class AddScheduleToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :schedule, :date
  end
end
