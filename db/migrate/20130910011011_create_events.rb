class CreateEvents < ActiveRecord::Migration
  def change
      create_table :events do |t|
        t.belongs_to  :project
        t.date        :date
        t.integer     :hour
        t.timestamps
      end
  end
end
