class Project < ActiveRecord::Base
  belongs_to :owner, class_name: "User", foreign_key: :owner_id
  has_many   :donations
  has_many   :donators, through: :donations, source: :user

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
end
