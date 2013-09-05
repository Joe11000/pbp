class AddDeadlineColumnToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :deadline, :datetime, null: false
  end
end
