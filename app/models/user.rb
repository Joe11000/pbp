class User < ActiveRecord::Base
  has_many :created_projects, class_name: "Project", foreign_key: :owner_id
  has_many :donations
  has_many :donated_projects, class_name: "Project", through: :donations

  validates_presence_of :email

  validates_uniqueness_of :email

  attr_accessible :donations, :created_projects, :donated_projects

  def self.from_omniauth(auth)
    if auth.provider == "facebook"
      if user = self.find_by_fb_uid(auth.uid)
        user
      else
        user = self.new
        user.email = auth.info.email
        user.first_name = auth.info.first_name
        user.last_name = auth.info.last_name
        user.location = auth.info.location
        user.fb_uid = auth.uid
        user.fb_nickname = auth.info.nickname
        user.fb_avatar_url = auth.info.image
        user.fb_oauth = auth.credentials.token
        user.fb_oauth_expires_at = auth.credentials.expires_at
        user.save
        user
      end
    end
  end 
end
