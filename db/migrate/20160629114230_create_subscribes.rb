class CreateSubscribes < ActiveRecord::Migration
  def change
    create_table :subscribes do |t|

      t.integer :user_id, :index => true
      t.integer :topic_id, :index => true

      t.timestamps null: false
    end
  end
end
