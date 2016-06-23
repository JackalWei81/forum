class CreateTopicCategoryships < ActiveRecord::Migration
  def change
    create_table :topic_categoryships do |t|

      t.integer :topic_id,  :index => true
      t.integer :category_id, :index =>true

      t.timestamps null: false
    end
  end
end
