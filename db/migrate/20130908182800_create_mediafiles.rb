class CreateMediafiles < ActiveRecord::Migration
  def change
    create_table :mediafiles do |t|
      t.string  :name 
      t.string  :url 
      t.string  :media_type 
      t.integer :project_id 
      t.timestamps 
    end 
  end 
end
