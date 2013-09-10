class Commitment < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  has_one :project, through: :event

  attr_accessible :user_id, :event_id
end
