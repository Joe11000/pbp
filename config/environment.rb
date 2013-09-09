# Load the rails application
require File.expand_path('../application', __FILE__)

# Setup ActionMailer

ActionMailer::Base.smtp_settings = {
  :port           => ENV['MAILGUN_SMTP_PORT'], 
  :address        => ENV['MAILGUN_SMTP_SERVER'],
  :user_name      => ENV['MAILGUN_SMTP_LOGIN'],
  :password       => ENV['MAILGUN_SMTP_PASSWORD'],
  :domain         => 'desolate-oasis-7380.heroku.com',
  :authentication => :plain,
}
ActionMailer::Base.delivery_method = :smtp

# Initialize the rails application
ParkBenchProjects::Application.initialize!
