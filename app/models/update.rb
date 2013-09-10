class Update <  ActiveRecord::Base
  belongs_to :project

  attr_accessible :title, :body, :update_date
end
