class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|

      t.string :name
      t.attachment :photo
      t.integer :topic_id, :index => true

      t.timestamps null: false
    end
  end
end