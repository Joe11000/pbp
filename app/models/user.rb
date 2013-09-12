require 'balanced'

Balanced.configure(ENV["BALANCED_SECRET"])

class User < ActiveRecord::Base
  has_many :created_projects, class_name: "Project", foreign_key: :owner_id
  has_many :donations
  has_many :donated_projects, through: :donations, source: :project 

  validates_presence_of :first_name, :last_name, :email, :location, :nickname
  validates_uniqueness_of :email

  attr_accessible :donations, :created_projects, :donated_projects, :first_name,
                  :last_name, :email, :location, :password, :password_confirmation,
                  :fb_uid, :fb_nickname, :fb_avatar_url, :fb_oauth, :fb_oauth_expires_at,
                  :twitter_uid, :twitter_nickname, :twitter_avatar_url, :twitter_key,
                  :twitter_secret, :avatar, :nickname, :password_digest

  has_secure_password

  def self.find_or_build_from_omniauth(auth)
    if auth.provider == "facebook"
      find_or_build_from_facebook(auth)
    elsif auth.provider == "twitter"
      find_or_build_from_twitter(auth)
    end
  end

  def self.find_or_build_from_facebook(auth)
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
      user.nickname = user.fb_nickname
      user.fb_avatar_url = auth.info.image
      user.avatar = user.fb_avatar_url
      user.fb_oauth = auth.credentials.token
      user.fb_oauth_expires_at = auth.credentials.expires_at

      user.password = user.password_confirmation = ""
      user.password_digest = "123facebook-authorized account123"
      user
    end
  end

  def self.find_or_build_from_twitter(auth)
    if user = self.find_by_twitter_uid(auth.uid)
      user
    else
      user = self.new
      user.location = auth.info.location
      user.twitter_uid = auth.uid
      user.twitter_nickname = auth.info.nickname
      user.nickname = user.twitter_nickname
      user.twitter_avatar_url = auth.info.image
      user.avatar = user.twitter_avatar_url
      user.twitter_key = auth.credentials.token
      user.twitter_secret = auth.credentials.secret

      user.password = user.password_confirmation = ""
      user.password_digest = "123twitter-authorized account123"
      user
    end
  end

  def special_save
    self.save if self.password && self.password_confirmation
    if self.twitter_uid || self.fb_uid
      self.password = "testtest"
      self.password_confirmation = "testtest"
    end
    self.save
  end

  # methods for mailers (both testing and sending)

  def send_welcome
    UserMailer.welcome_email(self).deliver
  end

  # all of the stuff below is payments related - see https://docs.balancedpayments.com/current/api

  # this is only ever used for testing.  Cards are tokenized by balanced in prod
  def get_card_token
    card = Balanced::Card.new
    card.uri = "/v1/marketplaces/TEST-MPv0uxteFANO0h9xY5c6Lrq/cards"
    card.name = self.first_name + " " + self.last_name
    card.email = self.email
    card.card_number = "4111111111111111"
    card.expiration_month = "10"
    card.expiration_year = "2020"
    card.save.attributes["uri"]
  end

  # this is also only ever used for testing.  Bank accounts are tokenized by balanced in prod
  def get_bankaccount_token(bankaccount_details)
    response = Balanced::BankAccount.new(bankaccount_details).save
    response.attributes["uri"]
  end

  def balanced_customer
    unless self.balanced_customer_uri
      response = Balanced::Customer.new(name: "#{self.first_name} #{self.last_name}",
                             email: self.email).save

      self.balanced_customer_uri = response.attributes["uri"]
    end
    Balanced::Customer.find(self.balanced_customer_uri)
  end

  def set_customer_token(card_uri = get_card_token)
    balanced_customer.add_card(card_uri)
  end

  def set_bankaccount_token(bankaccount_uri)
    balanced_customer.add_bank_account(bankaccount_uri)
  end

  def donations
      Donation.where(user_id: self.id) if self.id
  end 
end
