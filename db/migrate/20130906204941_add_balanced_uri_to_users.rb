class AddBalancedUriToUsers < ActiveRecord::Migration
  def change
    add_column :users, :balanced_uri, :string
  end
end
