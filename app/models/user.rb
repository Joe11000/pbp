require 'balanced'

Balanced.configure(ENV["BALANCED_SECRET"])

class User < ActiveRecord::Base
  has_many :created_projects, class_name: "Project", foreign_key: :owner_id
  has_many :donations
  has_many :donated_projects, through: :donations, source: :project

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

  # this is only ever used for testing.  Cards are tokenized by balanced in prod
  def get_card_token(card_details)
    response = Balanced::Card.new(card_details).save
    response.attributes["uri"]
  end

  def set_customer_token(card_uri)
    response = Balanced::Customer.new(name: "#{self.first_name} #{self.last_name}",
                                        card_uri: card_uri,
                                        email: self.email).save
    self.balanced_customer_uri = response.attributes["uri"]
  end
end
