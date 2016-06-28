class AddOmniauthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fb_uid, :string, :index => true
    add_column :users, :fb_token, :string

  end
end
