class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.belongs_to :user, null: false, index: true
      t.belongs_to :project, null: false, index: true
      t.integer    :hours, default: 0
      t.integer    :dollar_amount, default: 0
      t.timestamps
    end
  end
end
