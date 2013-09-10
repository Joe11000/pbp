class Event < ActiveRecord::Base
  attr_accessible :start_time

  belongs_to :project
  has_many :user_availabilities, dependent: :destroy
end
