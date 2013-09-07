class AddBalancedCustomerUri < ActiveRecord::Migration
  def up
    add_column :users, :balanced_customer_uri, :string
  end

  def down
    remove_column :users, :balanced_customer_uri, :string
  end
end
