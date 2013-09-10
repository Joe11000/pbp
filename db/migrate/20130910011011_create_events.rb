class CreateEvents < ActiveRecord::Migration
  def change
      create_table :events do |t|
        t.belongs_to  :project
        t.datetime    :start_time
        t.timestamps
      end
  end
end
