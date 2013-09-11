class Mediafile < ActiveRecord::Base
  belongs_to :project

  validates_presence_of :url, :media_type, :project_id

  attr_accessible :url, :name, :media_type, :project_id
end
