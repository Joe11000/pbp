class AddTwitterColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :twitter_uid, :string
    add_column :users, :twitter_nickname, :string
    add_column :users, :twitter_avatar_url, :string
    add_column :users, :twitter_key, :string
    add_column :users, :twitter_secret, :string
    add_column :users, :method_of_contact, :string
    add_column :users, :nickname, :string
    add_column :users, :avatar, :string
    add_column :users, :password_digest, :string
    add_column :users, :admin, :boolean, default: false
  end
end
