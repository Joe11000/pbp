class Event < ActiveRecord::Base
  belongs_to :project
  has_many :commitments, dependent: :destroy
  has_many :users, through: :commitments
 
  attr_accessible :date, :hour, :project_id

  def start_time
    self.date
  end

  def month_day
    self.start_time.day
  end
end
