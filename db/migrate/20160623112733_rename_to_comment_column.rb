class RenameToCommentColumn < ActiveRecord::Migration
  def change
    rename_column :comments, :nmae, :name
  end
end
