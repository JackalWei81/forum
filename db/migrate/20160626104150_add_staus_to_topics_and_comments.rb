class AddStausToTopicsAndComments < ActiveRecord::Migration
  def change
    add_column :topics, :status, :string
    add_column :comments, :status, :string
  end
end
