class Project < ActiveRecord::Base
  belongs_to :owner, class_name: "User", foreign_key: :owner_id
  has_many   :donations
  has_many   :donators, through: :donations, source: :user
  has_many   :events, dependent: :destroy

  validates_presence_of :owner, :title, :description
  validates_uniqueness_of :title

  attr_accessible :owner, :title, :description, :hour_goal, :dollar_goal, :deadline

  def hours_donated
    self.donations.sum("hours")
  end

  def hours_remaining
    hour_goal - hours_donated
  end

  def dollars_donated
    self.donations.sum("dollar_amount")
  end

  def dollars_remaining
    dollar_goal - dollars_donated
  end

  def time_remaining
    (deadline.to_i - DateTime.now.to_i) / (24 * 60 * 60)
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
    hours_remaining <= 0 && dollars_remaining <= 0
  end

  def get_events_for_day(date)
    puts "HERE"
    self.events.keep_if { |event| event.start_time.strftime("%Y-%m-%d") == date }
  end
end
