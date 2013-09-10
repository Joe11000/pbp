class Update <  ActiveRecord::Base
  belongs_to :project

  validates_presence_of :title, :body

  attr_accessible :title, :body
end
