class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, index: true
      t.string :first_name
      t.string :last_name
      t.string :location
      t.string :fb_uid
      t.string :fb_nickname
      t.string :fb_avatar_url
      t.string :fb_oauth
      t.string :fb_oauth_expires_at
      t.timestamps 
    end
  end
end
