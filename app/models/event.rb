class Event < ActiveRecord::Base
  belongs_to :project
  has_many :commitments, dependent: :destroy
  has_many :users, through: :commitments

  attr_accessor :attendance

  validates_presence_of :date, :hour, :project_id

  attr_accessible :date, :hour, :project_id, :attendance

  after_initialize :set_attendance

  def start_time
    self.date
  end

  def month_day
    self.start_time.day
  end

  def set_attendance
    self.attendance = self.users.size
    self.save
  end

  def self.create_default(project_id)
    date = DateTime.now
    event = Event.create(date: "#{date.year}-#{date.month}-#{date.day + 1}", hour: date.hour, project_id: project_id)
  end
end
