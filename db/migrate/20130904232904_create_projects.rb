class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.belongs_to :owner, null: false
      t.string     :title, null: false, unique: true, index: true
      t.text       :description, null: false
      t.integer    :hour_goal, default: 0
      t.integer    :dollar_goal, default: 0
      t.timestamps
    end
  end
end
