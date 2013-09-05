class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.belongs_to :user, null: false, index: true
      t.belongs_to :project, null: false, index: true
      t.integer    :hours, default: 0
      t.decimal    :dollar_amount, :precision => 8, :scale => 2, default: 0.00
      t.timestamps
    end
  end
end
