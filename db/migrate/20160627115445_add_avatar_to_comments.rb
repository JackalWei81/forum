class AddAvatarToComments < ActiveRecord::Migration
  def change
    add_attachment :comments, :avatar
  end
end
