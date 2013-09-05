class User < ActiveRecord::Base
  has_many :created_projects, class_name: "Project", foreign_key: :owner_id
  has_many :donations
  has_many :donated_projects, class_name: "Project", through: :donations

  validates_presence_of :name, :email

  attr_accessible :name, :email, :donations, :created_projects, :donated_projects
end
