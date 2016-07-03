class AddColumnToPictures < ActiveRecord::Migration
  def change

    add_column :pictures, :photo, :attachment
    add_column :pictures, :comment_id, :integer, :index => true

  end
end
