class CreateCommitment < ActiveRecord::Migration
  def change
      create_table :commitments do |t|
        t.belongs_to :user
        t.belongs_to :event
      end
  end
end
