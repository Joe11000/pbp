class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.belongs_to :owner, class_name: "User", null: false
      t.string     :title, null: false, index: true
      t.text       :description, null: false
      t.integer    :hour_goal, default: 0
      t.money      :dollar_goal, default: 0.00
      t.timestamps
    end
  end
end
