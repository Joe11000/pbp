class Project < ActiveRecord::Base
  belongs_to :owner, class_name: "User", foreign_key: :owner_id
  has_many   :donations
  has_many   :donators, through: :donations, source: :user
  has_many   :mediafiles
  has_many   :updates
  has_many   :events, dependent: :destroy

  validates_presence_of :owner, :title, :description, :deadline
  validates_uniqueness_of :title

  attr_accessible :owner, :title, :description, :hour_goal, :dollar_goal, :find_all_by_deadline, :deadline
  accepts_nested_attributes_for :mediafiles

  before_save   :convert_to_cents_if_dollar_goal_updated

  def hours_donated
    self.donations.sum("hours")
  end

  def hours_remaining
    hour_goal - hours_donated
  end

  def get_dollar_goal
    (self.dollar_goal / 100.00).floor
  end

  def get_dollars_donated
    ((self.donations.sum("dollar_amount"))/ 100.00).floor
  end

  def get_dollars_remaining
    get_dollar_goal - get_dollars_donated
  end

  def time_remaining
    remaining = deadline.to_i - DateTime.now.to_i
    return remaining / (24 * 60 * 60) if remaining > 24 * 60 * 60
    remaining / (24 * 60)
  end

  def self.charge_ending_projects
    self.find_all_by_deadline(DateTime.now.midnight).each do |project|
      project.donations.each do |donation|
        #This print is intentional
        p donation.debit_amount
      end
    end
  end

  def funded?
    hours_remaining <= 0 && get_dollars_remaining <= 0
  end

  def strip_media
    self.description.scan(/<iframe.*<\/iframe>/).each do |match|
      self.mediafiles.create(url: match, media_type: "video")
    end

    self.description.scan(/!\[.*\]\((.*)\)/).each do |match|
      m = self.mediafiles.create(url: match[0], media_type: "photo" )
      puts m.valid?
      puts m.url
    end
  end

  def get_events_for_day(date)
    self.events.keep_if { |event| event.date.strftime("%Y-%m-%d") == date }
  end

  def get_events
    Event.create_default(id) if self.events.empty?
    self.events
  end

  def update_events(events)
    new_events = []
    events.each do |day|
      day = day[1]
      day["hours"].each do |hour|
        new_events << self.events.find_or_create_by_date_and_hour(day["date"], hour.to_i)
      end
    end

    self.events.each do |event|
      event.destroy unless new_events.include?(event)
    end
  end

  private

  def convert_to_cents_if_dollar_goal_updated
    if ! self.id
      dollar_goal_to_cents_into_db
    elsif Project.find(self.id).dollar_goal / 100.00 != self.dollar_goal
      dollar_goal_to_cents_into_db
    end
  end

  def dollar_goal_to_cents_into_db
    self.dollar_goal = self.dollar_goal * 100
  end
end
