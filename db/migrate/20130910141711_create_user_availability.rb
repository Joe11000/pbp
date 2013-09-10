class CreateUserAvailability < ActiveRecord::Migration
  def change
      create_table :user_availabilities do |t|
        t.belongs_to :user
        t.belongs_to :event
      end
  end
end
